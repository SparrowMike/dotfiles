function pine()
    require('rose-pine').setup({
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

function catppuccin()
    require("catppuccin").setup({
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

function gruv()
    vim.g.gruvbox_contrast_dark = 'medium'
    vim.g.gruvbox_contrast_light = 'medium'
    vim.g.gruvbox_termcolors = 16

    vim.g.gruvbox_italic = 1
end

function ColorMyPencils(color) 
    color = color or 'rose-pine'

    if (color == 'catppuccin') then
        catppuccin()
    end

    if (color == 'rose-pine') then
        pine()
    end

    if (color == 'gruvbox') then
        gruv()
    end

    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils('rose-pine');
