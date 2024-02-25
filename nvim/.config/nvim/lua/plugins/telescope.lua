return {
    {
        "nvim-telescope/telescope.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local config = require("telescope")

            config.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            config.load_extension("session-lens")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set('n', '<leader>pg', builtin.git_files, {})

            vim.keymap.set('n', '<C-f>', builtin.grep_string, {})
            vim.keymap.set("n", "<leader>gf", builtin.live_grep, {})

            require("telescope").load_extension("ui-select")
        end,
    },
}
