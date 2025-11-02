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
	{
		"luckasRanarison/tailwind-tools.nvim",
		event = "BufRead",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			local signs = {
				-- Error = "●",
				-- Warn = "●",
				-- Hint = "●",
				-- Info = "●",
				-- Error = "",
				Warn = "",
				Hint = "",
				-- Info = "",
				Error = "✘",
				-- Warn = "⚠",
				-- Hint = "⚡",
				Info = "ℹ",
			}

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
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
					vim.api.nvim_command("cfirst")
				else
					vim.api.nvim_command("copen")
				end
			end

			-- Enhanced LSP configuration
			lsp_zero.on_attach(function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				-- Add document highlight if supported
				if client.server_capabilities.documentHighlightProvider then
					local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
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
				-- Toggle inline diagnostics
				vim.keymap.set("n", "<leader>td", function()
					local current = vim.diagnostic.config().virtual_text
					vim.diagnostic.config({
						virtual_text = not current,
						underline = true,
						signs = true,
					})
				end, { desc = "Toggle inline diagnostics", buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ buffer = bufnr, remap = false, desc = "Code actions" }
				)
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
				vim.keymap.set(
					"i",
					"<C-h>",
					vim.lsp.buf.signature_help,
					{ buffer = bufnr, remap = false, desc = "Signature help" }
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

								-- Also check for package.json with eslintConfig or eslint-config packages
								local has_package_config = false
								local package_json_root = root_pattern("package.json")(vim.api.nvim_buf_get_name(bufnr))
								if package_json_root then
									local package_json_path = package_json_root .. "/package.json"
									local ok, package_content = pcall(vim.fn.readfile, package_json_path)
									if ok and package_content then
										local package_str = table.concat(package_content, "\n")
										has_package_config = string.match(package_str, '"eslintConfig"')
											or string.match(package_str, '"eslint%-config%-')
											or string.match(package_str, '"@.*/eslint%-config')
									end
								end

								-- Only attach if config exists
								if not root_dir and not has_package_config then
									client.stop()
									return
								end

								-- Check for eslint binary in node_modules or globally
								local search_root = root_dir or package_json_root
								local local_binary = nil
								if search_root then
									local_binary = vim.fs.find("node_modules/.bin/eslint", { path = search_root, upward = true })[1]
								end

								if not local_binary and vim.fn.executable("eslint") ~= 1 then
									client.stop()
									return
								end

								-- Standard on_attach from lsp_zero
								require("lsp-zero").on_attach(client, bufnr)
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
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = false,
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
								client.server_capabilities.completionProvider.triggerCharacters = {
									">", -- Only trigger after a tag character
									"/", -- For self-closing tags
									"}", -- For JSX expressions
								}
							end,
						})
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
