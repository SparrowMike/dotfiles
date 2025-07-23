return {
	"eandrju/cellular-automaton.nvim",
	config = function()
		vim.keymap.set("n", "<leader>jjj", ":CellularAutomaton make_it_rain<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>jjk", ":CellularAutomaton scramble<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>jjl", ":CellularAutomaton game_of_life<CR>", { noremap = true, silent = true })
	end,
}
