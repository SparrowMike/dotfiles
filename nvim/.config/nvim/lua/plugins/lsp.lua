return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = false,
		config = false,
		init = function()
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
		dependencies = { "jay-babu/mason-null-ls.nvim" },
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "VonHeikemen/lsp-zero.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			-- Pyright: completions/navigation only, type checking off (ruff handles flake8-style linting)
			-- vim.lsp.config("pyright", {
			-- 	settings = {
			-- 		python = {
			-- 			analysis = {
			-- 				autoSearchPaths = true,
			-- 				useLibraryCodeForTypes = true,
			-- 				typeCheckingMode = "off",
			-- 				reportMissingImports = false,
			-- 				reportMissingModuleSource = false,
			-- 				extraPaths = {
			-- 					"lib/python",
			-- 					"var/dbapi",
			-- 					"api",
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })

			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "ℹ",
					},
				},
				virtual_text = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- Filter function for handling multiple definitions
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

			-- Enhanced LSP configuration
			lsp_zero.on_attach(function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				-- Add document highlight if supported
				if client.server_capabilities.documentHighlightProvider then
					-- Use buffer-specific group name to prevent conflicts and memory leaks
					local group_name = "LSPDocumentHighlight_" .. bufnr
					local group = vim.api.nvim_create_augroup(group_name, { clear = true })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})

					-- Cleanup autogroup when buffer is deleted
					vim.api.nvim_create_autocmd("BufDelete", {
						buffer = bufnr,
						once = true,
						callback = function()
							pcall(vim.api.nvim_del_augroup_by_name, group_name)
						end,
					})
				end
				-- Keymappings
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition({ on_list = custom_on_list })
				end, { buffer = bufnr, remap = false, desc = "Go to definition" })
				vim.keymap.set(
					"n",
					"gD",
					vim.lsp.buf.declaration,
					{ buffer = bufnr, remap = false, desc = "Go to declaration" }
				)
				vim.keymap.set(
					"n",
					"gi",
					vim.lsp.buf.implementation,
					{ buffer = bufnr, remap = false, desc = "Go to implementation" }
				)
				vim.keymap.set(
					"n",
					"td",
					vim.lsp.buf.type_definition,
					{ buffer = bufnr, remap = false, desc = "Go to type definition" }
				)
				vim.keymap.set(
					"n",
					"K",
					vim.lsp.buf.hover,
					{ buffer = bufnr, remap = false, desc = "Show hover information" }
				)
				vim.keymap.set(
					"n",
					"<leader>vws",
					vim.lsp.buf.workspace_symbol,
					{ buffer = bufnr, remap = false, desc = "Workspace symbols" }
				)
				vim.keymap.set(
					"n",
					"<leader>vd",
					vim.diagnostic.open_float,
					{ buffer = bufnr, remap = false, desc = "Open diagnostic float" }
				)
				vim.keymap.set(
					"n",
					"[d",
					vim.diagnostic.goto_prev,
					{ buffer = bufnr, remap = false, desc = "Go to previous diagnostic" }
				)
				vim.keymap.set(
					"n",
					"]d",
					vim.diagnostic.goto_next,
					{ buffer = bufnr, remap = false, desc = "Go to next diagnostic" }
				)
				vim.keymap.set("n", "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, { buffer = bufnr, remap = false, desc = "Code actions" })
				vim.keymap.set(
					"n",
					"<leader>vrr",
					vim.lsp.buf.references,
					{ buffer = bufnr, remap = false, desc = "Show references" }
				)
				vim.keymap.set(
					"n",
					"<leader>vrn",
					vim.lsp.buf.rename,
					{ buffer = bufnr, remap = false, desc = "Rename symbol" }
				)
				-- Changed from <C-h> in insert mode to avoid conflict with tmux navigation
				-- K = hover info, H = signature help (simple pairing)
				vim.keymap.set(
					"n",
					"H",
					vim.lsp.buf.signature_help,
					{ buffer = bufnr, remap = false, desc = "LSP Signature help" }
				)
				vim.keymap.set("n", "<leader>wr", function()
					local folders = vim.lsp.buf.list_workspace_folders()
					-- Convert to set to remove duplicates
					local unique_folders = {}
					for _, folder in ipairs(folders) do
						unique_folders[folder] = true
					end
					-- Convert back to array
					local result = {}
					for folder, _ in pairs(unique_folders) do
						table.insert(result, folder)
					end
					print(vim.inspect(result))
				end, { buffer = bufnr, remap = false, desc = "List workspace folders" })
			end)

			-- LSP server configurations
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"rust_analyzer",
					"cssls",
					"html",
					-- "rustywind",
					-- "tailwindcss",
					"bashls",
					"jsonls",
					"eslint",
					"emmet_ls",
					"pyright",
					"ruff", -- Fast Python linter/formatter as LSP
				},

				-- automatic_installation = true,

				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())
					end,
					eslint = function()
						require("lspconfig").eslint.setup({
							-- Only start ESLint LSP when config exists and binary is available
							on_attach = function(client, bufnr)
								-- Check for ESLint config files
								local root_pattern = require("lspconfig.util").root_pattern
								local root_dir = root_pattern(
									".eslintrc",
									".eslintrc.js",
									".eslintrc.json",
									".eslintrc.yml",
									".eslintrc.yaml",
									"eslint.config.js"
								)(vim.api.nvim_buf_get_name(bufnr))

								-- Only attach if config exists
								if not root_dir then
									client.stop()
									return
								end

								-- Check for eslint binary in node_modules or globally
								local local_binary = vim.fs.find("node_modules/.bin/eslint", { path = root_dir, upward = true })[1]

								if not local_binary and vim.fn.executable("eslint") ~= 1 then
									client.stop()
									return
								end

								-- Note: lsp_zero.on_attach() is already called globally for all LSP servers
								-- No need to call it again here
							end,
							filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
							settings = {
								codeActionOnSave = {
									enable = false,
									mode = "all"
								},
								format = false,
							},
						})
					end,
					ts_ls = function()
						local inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						}

						require("lspconfig").ts_ls.setup({
							filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
							settings = {
								typescript = {
									inlayHints = inlayHints,
								},
								javascript = {
									inlayHints = inlayHints,
								},
								javascriptreact = {
									inlayHints = inlayHints,
								},
								typescriptreact = {
									inlayHints = inlayHints,
								},
							},
						})
					end,
					emmet_ls = function()
						require("lspconfig").emmet_ls.setup({
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
										-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
										["jsx.enabled"] = true,
										["bem.enabled"] = true,
									},
								},
							},
							on_attach = function(client, bufnr)
								if client.server_capabilities.completionProvider then
									client.server_capabilities.completionProvider.triggerCharacters = {
										">", -- Only trigger after a tag character
										"/", -- For self-closing tags
										"}", -- For JSX expressions
									}
								end
							end,
						})
					end,
					pyright = function()
						vim.lsp.enable("pyright")
					end,
					ruff = function()
						-- Auto-detects pyproject.toml configuration
						require("lspconfig").ruff.setup({})
					end,
				},
			})

		end,
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {},
	},
}
