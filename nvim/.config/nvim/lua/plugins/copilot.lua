return {
    'github/copilot.vim',
    config = function()
        vim.keymap.set('n', '<leader>cp', ':copilot panel<cr>')

        -- vim.keymap.set('i', '<c-c>', 'copilot#accept("\\<cr>")', {
        -- vim.keymap.set('i', '<tab>', 'copilot#accept("\\<tab>")', {
        --     expr = true,
        --     replace_keycodes = false
        -- })
        -- vim.g.copilot_no_tab_map = true
    end
}

