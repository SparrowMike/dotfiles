local themes = {
	rosepine = {
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
					transparency = true,
				},
			})
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	catppuccin = {
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
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

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	gruvbox = {
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
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
			local palette = vim.fn["gruvbox_material#get_palette"](
				configuration.background,
				configuration.foreground,
				configuration.colors_override
			)

			local highlights_groups = {
				NvimTreeNormal = { fg = palette.fg0[1], bg = palette.bg0[1] },
				NvimTreeRootFolder = { fg = palette.blue[1], bold = true },
				NvimTreeGitDirty = { fg = palette.yellow[1] }, -- using yellow for changes
				NvimTreeGitNew = { fg = palette.green[1] }, -- using green for additions
				NvimTreeGitDeleted = { fg = palette.red[1] }, -- using red for deletions
				NvimTreeSpecialFile = { fg = palette.purple[1], underline = true },
				LspDiagnosticsError = { fg = palette.red[1] },
				LspDiagnosticsWarning = { fg = palette.yellow[1] },
				LspDiagnosticsInformation = { fg = palette.blue[1] },
				LspDiagnosticsHint = { fg = palette.green[1] },
				NvimTreeIndentMarker = { fg = palette.grey0[1] },
				NvimTreeImageFile = { fg = palette.fg0[1] },
				NvimTreeSymlink = { fg = palette.blue[1] },
			}

			for group, styles in pairs(highlights_groups) do
				vim.api.nvim_set_hl(0, group, styles)
			end

			vim.cmd.colorscheme("gruvbox-material")
		end,
	},

	gruvbox2 = {
	    "ellisonleao/gruvbox.nvim",
	    priority = 1000,
	    config = function()
	        vim.o.background = "dark"
	        vim.cmd([[colorscheme gruvbox]])
	    end,
	},

	tokyonight = {
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon", -- The theme comes in four styles: "night", "storm", "day", "moon"
				transparent = true,
				terminal_colors = true, -- Configure the colors used when opening a `:terminal`
				styles = {
					sidebars = "transparent",
					floats = "transparent",
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	oldworld = {
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oldworld").setup({
				styles = {
					booleans = { italic = true, bold = true },
				},
				integrations = {
					hop = true,
					telescope = false,
				},
				highlight_overrides = {
					Comment = { bg = "#ff0000" },
				},
			})

			vim.cmd.colorscheme("oldworld")
		end,
	},
}

return themes.gruvbox
