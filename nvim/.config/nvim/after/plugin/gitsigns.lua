require('gitsigns').setup()

-- require('gitsigns').setup({
--   keymaps = {
--     noremap = true,
--     buffer = true,
--     ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
--     ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
--   }
-- })

vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>ga', ':Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>gb', ':gitsigns blame_line<cr>')

-- add 5 must have features for gitsigns
