return {
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
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
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
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
					},
				},
			})

			-- Enable HTML snippets in JS(X)/TS(X) files
			luasnip.filetype_extend("javascript", { "html" })
			luasnip.filetype_extend("javascriptreact", { "html" })
			luasnip.filetype_extend("typescriptreact", { "html" })

			-- Load snippets from VS Code
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
