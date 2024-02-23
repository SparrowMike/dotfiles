return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set('n', '<leader>gs', ":vert Git<CR>")
        vim.keymap.set('n', '<leader>gd', vim.cmd.Gvdiff)
    end,
}
