return {
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>pg", builtin.git_files, {})
            vim.keymap.set("n", "<C-f>", builtin.grep_string, {})
            vim.keymap.set("n", "<leader>gf", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end,
    },
}
