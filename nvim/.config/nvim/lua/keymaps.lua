-- greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Open file explorer (netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer (netrw)" })

-- Clear search highlighting
vim.keymap.set("n", "<leader>hh", ":noh<CR>", { desc = "Clear search highlighting" })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Paste over selected text without replacing clipboard contents
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection without losing clipboard content" })

-- Replace word under cursor (normal mode)
-- vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor (normal mode)" }
)

-- Replace selection (visual mode)
vim.keymap.set(
	"v",
	"<leader>rw",
	[[y:%s/\V<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
	{ desc = "Replace selected text" }
)

-- Center cursor after moving half a page down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

-- Copy relative file path to clipboard
vim.keymap.set("n", "<leader>cp", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path to clipboard" })

vim.keymap.set("n", "yyc", function()
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- Duplicate line below
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })

  -- Comment out original line
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "// " .. line })

  -- Move cursor to the new (uncommented) line below
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end, { desc = "Copy line down and comment out original" })

-- Quit commands
vim.keymap.set("n", "Q", ":qa!<CR>", { desc = "Quit all windows" })
vim.keymap.set("n", "qq", ":qa!<CR>", { desc = "Quit all windows" })
vim.keymap.set("n", "qw", ":q<CR>", { desc = "Quit current window" })

-- Window resizing
vim.keymap.set("n", "<M-i>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<M-u>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<M-o>", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<M-y>", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })
