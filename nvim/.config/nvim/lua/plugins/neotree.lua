return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        -- {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },

    config = function()
        local config = require("neo-tree")
        config.setup({
            enable_git_status = false,
            enable_diagnostics = false,
            auto_clean_after_session_restore = true,
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg)
                        vim.cmd([[setlocal relativenumber]])
                    end,
                },
            },
            window = {
                position = "right",
            },
            filesystem = {
                follow_current_file = {
                    enabled = true, -- This will find and focus the file in the active buffer every time
                },
                filtered_items = {
                    hide_dotfiles = false,
                },
            },
        })
        vim.keymap.set("n", "<C-B>", function()
            require("neo-tree.command").execute { source = "filesystem", toggle = true, position = "right" }
        end)

        vim.keymap.set("n", "<C-G>", function()
            require("neo-tree.command").execute { toggle = true, source = "git_status", position = "float" }
        end)

    end,
}
