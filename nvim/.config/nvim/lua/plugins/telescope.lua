return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = true,
        event = "VeryLazy"
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        keys = {
            { "<C-p>", desc = "Find files" },
            { "<leader>pg", desc = "Git files" },
            { "<C-f>", mode = { "n", "v" }, desc = "Grep string" },  -- Added visual mode
            { "<leader>gf", desc = "Grep input" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
                defaults = {
                    mappings = {},
                },
            })

            require("telescope").load_extension("ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-f>", builtin.grep_string, {})
            vim.keymap.set("v", "<C-f>", function()
                local saved_reg = vim.fn.getreg('"')
                vim.cmd('noau normal! "vy"')
                local search_term = vim.fn.getreg('v')
                vim.fn.setreg('"', saved_reg)
                builtin.grep_string({ search = search_term })
            end, {})

            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>pg", builtin.git_files, {})
            vim.keymap.set("n", "<C-f>", builtin.grep_string, {})
            vim.keymap.set("v", "<C-f>", function()
                local saved_reg = vim.fn.getreg('"')
                vim.cmd('noau normal! "vy"')
                local search_term = vim.fn.getreg('v')
                vim.fn.setreg('"', saved_reg)
                builtin.grep_string({ search = search_term })
            end, {})
            vim.keymap.set("n", "<leader>gf", function()
                local search_query = vim.fn.input("Grep > ")
                if search_query == "" then
                    print("Empty search string provided.")
                    return
                end
                require('telescope.builtin').grep_string({ search = search_query })
            end)
        end,
    }
}
