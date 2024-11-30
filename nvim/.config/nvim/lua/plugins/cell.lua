return {
    "eandrju/cellular-automaton.nvim",
    config = function()
        vim.keymap.set("n", "<leader>fmla", ":CellularAutomaton make_it_rain<CR>")
        vim.keymap.set("n", "<leader>fmls", ":CellularAutomaton game_of_life<CR>")
        vim.keymap.set("n", "<leader>fmld", ":CellularAutomaton scramble<CR>")
    end,
}
