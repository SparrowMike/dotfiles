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
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				max_width = 100,
				max_height = 40,
				title = "Hover",
				focusable = true,
				-- close_events = { "BufHidden", "InsertEnter" },
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
				end, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "td", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
				vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				-- Toggle inline diagnostics
				vim.keymap.set("n", "<leader>td", function()
					local current = vim.diagnostic.config().virtual_text
					vim.diagnostic.config({
						virtual_text = not current,
						underline = true,
						signs = true,
					})
				end, { desc = "Toggle inline diagnostics", buffer = bufnr })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
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
				end)
			end)
			-- LSP server configurations
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"rust_analyzer",
					"cssls",
					"html",
					"tailwindcss",
					"bashls",
					"jsonls",
					-- "eslint",
					"emmet_ls",
				},
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())
					end,
					-- automatic_installation = true,
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
