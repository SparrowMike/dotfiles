return {
    { "nvim-tree/nvim-web-devicons" },
    { "ryanoasis/vim-devicons" },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    -- component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { 
                        "branch",
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = " ",
                            },
                        }
                    },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,  -- Show relative path
                            symbols = { modified = "●" }
                        }
                    },
                    lualine_x = { "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" }
                }
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("notify").setup({
                timeout = 3000,
                background_colour = "#000000",
                render = "default",
                top_down = false,
                stages = "fade_in_slide_out",
            })

            require("noice").setup({
                lsp = {
                    signature = {
                        enabled = false,
                    },
                    hover = {
                        enabled = false,
                    },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = false, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
            })
            vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<cr>')
        end,
    },
}
