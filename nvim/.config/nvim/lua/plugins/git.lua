return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<leader>gts", ":vert Git<CR>")
            vim.keymap.set("n", "<leader>gtd", vim.cmd.Gvdiff)
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")

            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
        end,
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            vim.g.gitblame_display_virtual_text = 0
            vim.keymap.set("n", "<leader>gto", "<cmd>GitBlameOpenCommitURL<cr>")
            vim.keymap.set("n", "<leader>gtb", "<cmd>GitBlameToggle<cr>")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup({
                current_line_blame = false,
            })

            vim.keymap.set("n", "<leader>gtp", ":Gitsigns preview_hunk<CR>")
            vim.keymap.set("n", "<leader>gta", ":Gitsigns stage_hunk<CR>")
            vim.keymap.set("n", "<leader>gtu", ":Gitsigns undo_stage_hunk<CR>")
            vim.keymap.set("n", "<leader>gtr", ":Gitsigns reset_hunk<CR>")
            vim.keymap.set("n", "<leader>gtb", ":Gitsigns blame_line<CR>")
        end,
    },
}
