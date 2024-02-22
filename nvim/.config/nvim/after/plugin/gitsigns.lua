-- ! should be updated to lates config

require('gitsigns').setup({
  current_line_blame = true,
})

vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>ga', ':Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>')
