return {
    -- {
    --     "folke/persistence.nvim",
    --     event = "BufReadPre", -- this will only start session saving when an actual file was opened
    --     opts = {
    --         -- add any custom options here
    --     }
    -- },

    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},

                -- pre_save_cmds = { "Neotree close" },
                -- save_extra_cmds = {
                --     "Neotree open"
                -- },
                -- post_restore_cmds = {
                --     "Neotree open"
                -- }
            }
        end
    },
    -- {
    --     'rmagatti/session-lens',
    --     dependencies = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
    --     config = function()
    --         local config = require('session-lens')
    --         local telescope = require('telescope.themes').get_dropdown(theme_conf)
    --
    --         config.setup({
    --             -- path_display = {'shorten'},
    --             -- theme = 'ivy', -- default is dropdown
    --             theme_conf = { border = true, telescope },
    --             -- previewer = true
    --         })
    --
    --         vim.keymap.set('n', '<C-s>', ':SearchSession<CR>', {})
    --     end
    -- }
}
