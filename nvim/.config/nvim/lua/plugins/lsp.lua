return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"rust_analyzer",
				"cssls",
				"html",
				"bashls",
				"jsonls",
				"eslint",
				"emmet_ls",
				"pyright",
				"ruff",
			},
			automatic_installation = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "ℹ",
					},
				},
				virtual_text = true,
				underline = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function filter_react_dts(items)
				return vim.tbl_filter(function(item)
					return not string.match(item.filename or "", "react/index.d.ts")
				end, items)
			end

			local function custom_on_list(options)
				local items = filter_react_dts(options.items)
				vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
				if #items == 1 then
					vim.cmd.cfirst()
				else
					vim.cmd.copen()
				end
			end

			local hl_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					if client:supports_method("textDocument/documentHighlight") then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							group = hl_group,
							buffer = bufnr,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd("CursorMoved", {
							group = hl_group,
							buffer = bufnr,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					end

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, remap = false, desc = desc })
					end

					map("n", "gd", function()
						vim.lsp.buf.definition({ on_list = custom_on_list })
					end, "Go to definition")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
					map("n", "td", vim.lsp.buf.type_definition, "Go to type definition")
					map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
					map("n", "<leader>vd", vim.diagnostic.open_float, "Open diagnostic float")
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Go to previous diagnostic")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Go to next diagnostic")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
					map("n", "<leader>vrr", vim.lsp.buf.references, "Show references")
					map("n", "<leader>vrn", vim.lsp.buf.rename, "Rename symbol")
					map("n", "H", vim.lsp.buf.signature_help, "LSP Signature help")
					map("n", "<leader>wr", function()
						local seen = {}
						for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
							seen[folder] = true
						end
						print(vim.inspect(vim.tbl_keys(seen)))
					end, "List workspace folders")
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
				callback = function(args)
					vim.api.nvim_clear_autocmds({ group = hl_group, buffer = args.buf })
				end,
			})

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			})

			local ts_inlay_hints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			}

			vim.lsp.config("ts_ls", {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				settings = {
					typescript = { inlayHints = ts_inlay_hints },
					javascript = { inlayHints = ts_inlay_hints },
					javascriptreact = { inlayHints = ts_inlay_hints },
					typescriptreact = { inlayHints = ts_inlay_hints },
				},
			})

			vim.lsp.config("eslint", {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				on_attach = function(client, bufnr)
					local root_dir = vim.fs.root(bufnr, {
						".eslintrc",
						".eslintrc.js",
						".eslintrc.json",
						".eslintrc.yml",
						".eslintrc.yaml",
						"eslint.config.js",
						"eslint.config.mjs",
					})

					if not root_dir then
						client:stop()
						return
					end

					local local_binary = vim.fs.find("node_modules/.bin/eslint", { path = root_dir, upward = true })[1]
					if not local_binary and vim.fn.executable("eslint") ~= 1 then
						client:stop()
						return
					end
				end,
				settings = {
					codeActionOnSave = {
						enable = false,
						mode = "all",
					},
					format = false,
				},
			})

			vim.lsp.config("emmet_ls", {
				filetypes = {
					"css",
					"html",
					"javascript",
					"javascriptreact",
					"typescriptreact",
				},
				init_options = {
					html = {
						options = {
							["jsx.enabled"] = true,
							["bem.enabled"] = true,
						},
					},
				},
				on_attach = function(client, _)
					if client.server_capabilities.completionProvider then
						client.server_capabilities.completionProvider.triggerCharacters = { ">", "/", "}" }
					end
				end,
			})

			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"rust_analyzer",
				"cssls",
				"html",
				"bashls",
				"jsonls",
				"eslint",
				"emmet_ls",
				"pyright",
				"ruff",
			})
		end,
	},
}
