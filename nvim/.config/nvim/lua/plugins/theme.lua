return {
    { "catppuccin/nvim",
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
                }
            })
        end
    },

    {
        'rose-pine/neovim', name = 'rose-pine',
        config = function() 
            local config = require('rose-pine')
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
        end
    },

    { 
        "morhetz/gruvbox", name = "gruvbox",
        config = function() 
            vim.g.gruvbox_contrast_dark = 'medium'
            vim.g.gruvbox_contrast_light = 'medium'
            vim.g.gruvbox_termcolors = 16

            vim.g.gruvbox_italic = 1

            vim.cmd.colorscheme('gruvbox')

            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end
    },

}
