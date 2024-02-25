return   {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { 
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        -- {
    },
    config = function()
        local config = require("neo-tree")
        config.setup({
            window = {
                position = "right",
            },
            filesystem = {
                follow_current_file = {
                    enabled = true, -- This will find and focus the file in the active buffer every time
                    --               -- the current file is changed while the tree is open.
                },
            }
        })

        vim.keymap.set('n', '<C-B>', ':Neotree source=filesystem toggle position=right<CR>')
        vim.keymap.set('n', '<C-G>', ':Neotree float git_status<CR>')
    end,
}

