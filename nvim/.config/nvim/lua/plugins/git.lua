return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", ":vert Git<CR>")
            vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiff)
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
        end,
    },
    {
        "f-person/git-blame.nvim",
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            vim.g.gitblame_display_virtual_text = 0
            vim.keymap.set("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>")
            -- vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = false,
            })

            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>")
            vim.keymap.set("n", "<leader>ga", ":Gitsigns stage_hunk<CR>")
            vim.keymap.set("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>")
            vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
            vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
        end,
    },
}
