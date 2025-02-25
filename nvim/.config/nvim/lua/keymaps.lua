vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>hh", ":noh<CR>")

-- ?
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>rw", [[y:%s/\V<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

vim.keymap.set("n", "<leader>cp", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path to clipboard" })

vim.keymap.set("n", "qq", ":qa<CR>", { desc = "Quit all windows" })
vim.keymap.set("n", "qw", ":q<CR>", { desc = "Quit current window" })

vim.keymap.set("n", "<M-i>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<M-u>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<M-o>", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<M-y>", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })

vim.keymap.set("n", "<leader>to", ":tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true, silent = true })
