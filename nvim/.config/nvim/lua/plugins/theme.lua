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
        "morhetz/gruvbox",
        name = "gruvbox",
        config = function()
            -- vim.g.gruvbox_contrast_dark = "medium"
            -- vim.g.gruvbox_contrast_light = "medium"
            -- vim.g.gruvbox_termcolors = 16
            -- vim.g.gruvbox_italic = 1
            -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            -- vim.cmd.colorscheme("gruvbox")
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- gruvbox = {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000,
    --     config = function()
    --         vim.o.background = "dark"
    --         vim.cmd([[colorscheme gruvbox]])
    --     end,
    -- },

    tokyonight = {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup {
                transparent = true,
                styles = {
                   sidebars = "transparent",
                   floats = "transparent",
                }
            }
            vim.cmd([[colorscheme tokyonight-moon]])
        end,
    },
}

return themes.tokyonight;
