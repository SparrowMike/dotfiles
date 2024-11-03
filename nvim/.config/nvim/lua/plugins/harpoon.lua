return {
    "theprimeagen/harpoon",
    config = function()
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        vim.keymap.set("n", "<leader>a", mark.add_file)
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

        vim.keymap.set('n', '<leader>ha', "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>hs', "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", { desc = "Go to harpoon 2" })
        vim.keymap.set('n', '<leader>hd', "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", { desc = "Go to harpoon 3" })
        vim.keymap.set('n', '<leader>hf', "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", { desc = "Go to harpoon 4" })
        vim.keymap.set('n', '<leader>hg', "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", { desc = "Go to harpoon 5" })
    end
}
