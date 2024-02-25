return {
    'github/copilot.vim',
    config = function()
        vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>')

        --vim.keymap.set('i', '<Tab>', 'copilot#Accept("\\<Tab>")', {
        vim.keymap.set('i', '<C-C>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true
    end
}
