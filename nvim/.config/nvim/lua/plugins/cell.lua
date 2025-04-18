return {
    "eandrju/cellular-automaton.nvim",
    config = function()
        vim.keymap.set("n", "<leader>fmla", ":CellularAutomaton make_it_rain<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>fmls", ":CellularAutomaton game_of_life<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>fmld", ":CellularAutomaton scramble<CR>", { noremap = true, silent = true })
    end,
}
