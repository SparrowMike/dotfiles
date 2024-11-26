return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
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

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()
			local luasnip = require("luasnip")

			-- Enable HTML snippets in JS(X)/TS(X) files
			luasnip.filetype_extend("javascript", { "html" })
			luasnip.filetype_extend("javascriptreact", { "html" })
			luasnip.filetype_extend("typescriptreact", { "html" })

			require("luasnip/loaders/from_vscode").lazy_load()

			local lspkind = require("lspkind")

			-- Add snippet support
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "nvim_lsp_signature_help", priority = 900 },
					{ name = "luasnip", priority = 750 },
					{ name = "codeium", priority = 500 },
					{ name = "path", priority = 250 },
					{ name = "buffer", priority = 100, keyword_length = 3 },
				}),

				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
				},

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
						symbol_map = { Codeium = "" },
						before = function(entry, vim_item)
							vim_item = require("tailwind-tools.cmp").lspkind_format(entry, vim_item)
							return vim_item
						end,
					}),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})
		end,
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
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
				vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
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
					"eslint",
					"emmet_ls",
				},

				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())
					end,
					automatic_installation = true,
					ts_ls = function()
						require("lspconfig").ts_ls.setup({
							filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
							settings = {
								typescript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = false,
										includeInlayFunctionParameterTypeHints = true,
										includeInlayVariableTypeHints = true,
										includeInlayPropertyDeclarationTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										includeInlayEnumMemberValueHints = true,
									},
								},
								javascript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = false,
										includeInlayFunctionParameterTypeHints = true,
										includeInlayVariableTypeHints = true,
										includeInlayPropertyDeclarationTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										includeInlayEnumMemberValueHints = true,
									},
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
								"less",
								"sass",
								"scss",
								"pug",
								"typescriptreact",
								"vue",
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
						})
					end,
				},
			})
		end,
	},

	-- {
	--     'nvimdev/lspsaga.nvim',
	--     config = function()
	--         require('lspsaga').setup({})
	--     end,
	-- },
}
