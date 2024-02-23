return {
    'github/copilot.vim',
    config = function()
        vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>')

        -- assign double tab for copilot completition
        vim.keymap.set('i', '<C-C>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true
    end,j
}
