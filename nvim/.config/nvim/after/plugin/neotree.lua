require("neo-tree").setup({
  window = {
    position = "right",
  },
  filesystem = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
    },
  }
})

vim.keymap.set('n', '<C-B>', ':Neotree source=filesystem toggle position=right<CR>')
vim.keymap.set('n', '<C-G>', ':Neotree float git_status<CR>')

