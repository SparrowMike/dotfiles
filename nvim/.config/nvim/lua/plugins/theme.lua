return {
	{ "xero/miasma.nvim", lazy = true },
	{ "savq/melange-nvim", lazy = true },
	{ "embark-theme/vim", as = "embark", lazy = true },

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {
			disable_background = true,
			variant = "moon",
			dark_variant = "moon",
			dim_inactive_windows = false,
			styles = {
				bold = true,
				italic = true,
			},
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "frappe",
			background = {
				dark = "frappe",
				light = "frappe",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		},
	},

	{
		"sainnhe/gruvbox-material",
		lazy = true,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_better_performance = 1
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "moon",
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
			},
		},
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				colors = {
					theme = {
						all = { ui = { bg_gutter = "none" } },
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

						-- snacks.nvim custom highlights
						SnacksDashboardHeader = { fg = theme.vcs.removed },
						SnacksDashboardFooter = { fg = theme.syn.comment },
						SnacksDashboardDesc = { fg = theme.syn.identifier },
						SnacksDashboardIcon = { fg = theme.ui.special },
						SnacksDashboardKey = { fg = theme.syn.special1 },
						SnacksDashboardSpecial = { fg = theme.syn.comment },
						SnacksDashboardDir = { fg = theme.syn.identifier },
						SnacksProfilerIconInfo = { bg = theme.ui.bg_search, fg = theme.syn.fun },
						SnacksProfilerBadgeInfo = { bg = theme.ui.bg_visual, fg = theme.syn.fun },
						SnacksProfilerIconTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
						SnacksProfilerBadgeTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
						SnacksIndent = { fg = theme.ui.bg_p2, nocombine = true },
						SnacksIndentScope = { fg = theme.ui.pmenu.bg, nocombine = true },
						SnacksZenIcon = { fg = theme.syn.statement },
						SnacksInputIcon = { fg = theme.ui.pmenu.bg },
						SnacksInputBorder = { fg = theme.syn.identifier },
						SnacksInputTitle = { fg = theme.syn.identifier },
						SnacksPickerInputBorder = { fg = theme.syn.constant },
						SnacksPickerInputTitle = { fg = theme.syn.constant },
						SnacksPickerBoxTitle = { fg = theme.syn.constant },
						SnacksPickerSelected = { fg = theme.syn.number },
						SnacksPickerPickWinCurrent = { fg = theme.ui.fg, bg = theme.syn.number, bold = true },
						SnacksPickerPickWin = { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},
}
