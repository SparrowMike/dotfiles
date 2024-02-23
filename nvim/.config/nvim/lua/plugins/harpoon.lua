return {
    "theprimeagen/harpoon",
    config = function()
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        vim.keymap.set("n", "<leader>a", mark.add_file)
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

        vim.keymap.set('n', '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", { desc = "Go to harpoon 1" })
        vim.keymap.set('n', '<leader>6', "<cmd>lua require('harpoon.ui').nav_file(6)<CR>", { desc = "Go to harpoon 1" })
    end
}
