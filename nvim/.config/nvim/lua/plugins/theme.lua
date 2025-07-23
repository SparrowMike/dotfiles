return {
	{
		"xero/miasma.nvim",
		lazy = true,
		config = function()
			-- vim.cmd("colorscheme miasma")
		end,
	},
	{
		"savq/melange-nvim",
		lazy = true,
		config = function()
			-- vim.cmd("colorscheme melange")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			local config = require("rose-pine")
			config.setup({
				disable_background = true,
				variant = "moon", -- auto, main, moon, or dawn
				dark_variant = "moon", -- main, moon, or dawn
				dim_inactive_windows = false,
				styles = {
					bold = true,
					italic = true,
					-- transparency = true,
				},
			})
			-- vim.cmd.colorscheme("rose-pine")
		end,
	},

	{ "embark-theme/vim", as = "embark" },

	{
		lazy = false,
		priority = 1000,
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			local config = require("catppuccin")

			config.setup({
				flavour = "frappe", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					dark = "frappe",
					light = "frappe",
				},
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				pintegrations = {
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
			})

			-- vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"sainnhe/gruvbox-material",
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_better_performance = 1
			-- vim.g.gruvbox_material_foreground = 'mix'
			-- vim.g.gruvbox_material_background = 'hard'
			-- vim.g.gruvbox_material_ui_contrast = 'medium' -- The contrast of line numbers, indent lines, etc.
			-- vim.g.gruvbox_material_float_style = 'dim'

			local configuration = vim.fn["gruvbox_material#get_configuration"]()
			-- local palette = vim.fn["gruvbox_material#get_palette"](
			-- 	configuration.background,
			-- 	configuration.foreground,
			-- 	configuration.colors_override
			-- )

			-- local highlights_groups = {
			-- 	nvimtreenormal = { fg = palette.fg0[1], bg = palette.bg0[1] },
			-- 	nvimtreerootfolder = { fg = palette.blue[1], bold = true },
			-- 	nvimtreegitdirty = { fg = palette.yellow[1] }, -- using yellow for changes
			-- 	nvimtreegitnew = { fg = palette.green[1] }, -- using green for additions
			-- 	nvimtreegitdeleted = { fg = palette.red[1] }, -- using red for deletions
			-- 	nvimtreespecialfile = { fg = palette.purple[1], underline = true },
			-- 	lspdiagnosticserror = { fg = palette.red[1] },
			-- 	lspdiagnosticswarning = { fg = palette.yellow[1] },
			-- 	lspdiagnosticsinformation = { fg = palette.blue[1] },
			-- 	lspdiagnosticshint = { fg = palette.green[1] },
			-- 	nvimtreeindentmarker = { fg = palette.grey0[1] },
			-- 	nvimtreeimagefile = { fg = palette.fg0[1] },
			-- 	nvimtreesymlink = { fg = palette.blue[1] },
			-- }
			--
			-- for group, styles in pairs(highlights_groups) do
			-- 	vim.api.nvim_set_hl(0, group, styles)
			-- end

			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- The theme comes in four styles: "night", "storm", "day", "moon"
				-- transparent = true,
				terminal_colors = true, -- Configure the colors used when opening a `:terminal`
				styles = {
					-- sidebars = "transparent",
					-- floats = "transparent",
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		-- overrides = function(colors)
		-- 	local theme = colors.theme
		-- 	return {
		-- 		Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
		-- 		PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
		-- 		PmenuSbar = { bg = theme.ui.bg_m1 },
		-- 		PmenuThumb = { bg = theme.ui.bg_p2 },
		-- 	}
		-- end,

		overrides = function(colors)
			local theme = colors.theme
			return {
				-- Transparent background
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none" },
				FloatTitle = { bg = "none" },

				NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
				LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

				-- Credit to https://github.com/rebelot/kanagawa.nvim/pull/268
				-- SnacksDashboard
				SnacksDashboardHeader = { fg = theme.vcs.removed },
				SnacksDashboardFooter = { fg = theme.syn.comment },
				SnacksDashboardDesc = { fg = theme.syn.identifier },
				SnacksDashboardIcon = { fg = theme.ui.special },
				SnacksDashboardKey = { fg = theme.syn.special1 },
				SnacksDashboardSpecial = { fg = theme.syn.comment },
				SnacksDashboardDir = { fg = theme.syn.identifier },
				-- SnacksNotifier
				SnacksNotifierBorderError = { link = "DiagnosticError" },
				SnacksNotifierBorderWarn = { link = "DiagnosticWarn" },
				SnacksNotifierBorderInfo = { link = "DiagnosticInfo" },
				SnacksNotifierBorderDebug = { link = "Debug" },
				SnacksNotifierBorderTrace = { link = "Comment" },
				SnacksNotifierIconError = { link = "DiagnosticError" },
				SnacksNotifierIconWarn = { link = "DiagnosticWarn" },
				SnacksNotifierIconInfo = { link = "DiagnosticInfo" },
				SnacksNotifierIconDebug = { link = "Debug" },
				SnacksNotifierIconTrace = { link = "Comment" },
				SnacksNotifierTitleError = { link = "DiagnosticError" },
				SnacksNotifierTitleWarn = { link = "DiagnosticWarn" },
				SnacksNotifierTitleInfo = { link = "DiagnosticInfo" },
				SnacksNotifierTitleDebug = { link = "Debug" },
				SnacksNotifierTitleTrace = { link = "Comment" },
				SnacksNotifierError = { link = "DiagnosticError" },
				SnacksNotifierWarn = { link = "DiagnosticWarn" },
				SnacksNotifierInfo = { link = "DiagnosticInfo" },
				SnacksNotifierDebug = { link = "Debug" },
				SnacksNotifierTrace = { link = "Comment" },
				-- SnacksProfiler
				SnacksProfilerIconInfo = { bg = theme.ui.bg_search, fg = theme.syn.fun },
				SnacksProfilerBadgeInfo = { bg = theme.ui.bg_visual, fg = theme.syn.fun },
				SnacksScratchKey = { link = "SnacksProfilerIconInfo" },
				SnacksScratchDesc = { link = "SnacksProfilerBadgeInfo" },
				SnacksProfilerIconTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
				SnacksProfilerBadgeTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
				SnacksIndent = { fg = theme.ui.bg_p2, nocombine = true },
				SnacksIndentScope = { fg = theme.ui.pmenu.bg, nocombine = true },
				SnacksZenIcon = { fg = theme.syn.statement },
				SnacksInputIcon = { fg = theme.ui.pmenu.bg },
				SnacksInputBorder = { fg = theme.syn.identifier },
				SnacksInputTitle = { fg = theme.syn.identifier },
				-- SnacksPicker
				SnacksPickerInputBorder = { fg = theme.syn.constant },
				SnacksPickerInputTitle = { fg = theme.syn.constant },
				SnacksPickerBoxTitle = { fg = theme.syn.constant },
				SnacksPickerSelected = { fg = theme.syn.number },
				SnacksPickerToggle = { link = "SnacksProfilerBadgeInfo" },
				SnacksPickerPickWinCurrent = { fg = theme.ui.fg, bg = theme.syn.number, bold = true },
				SnacksPickerPickWin = { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true },
			}
		end,
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				-- transparent = true, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = {
						wave = {},
						lotus = {},
						dragon = {},
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})

			-- vim.cmd.colorscheme("kanagawa")
		end,
	},
}
