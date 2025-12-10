-- https://github.com/ThePrimeagen/harpoon/blob/0378a6c428a0bed6a2781d459d7943843f374bce/lua/harpoon/ui.lua

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>aa", desc = "Add file to harpoon" },
        { "<C-e>", desc = "Toggle harpoon menu" },
        { "<leader>ha", desc = "Harpoon slot 1" },
        { "<leader>hs", desc = "Harpoon slot 2" },
        { "<leader>hd", desc = "Harpoon slot 3" },
        { "<leader>hf", desc = "Harpoon slot 4" },
        { "<leader>hg", desc = "Harpoon slot 5" },
        { "<leader>hz", desc = "Harpoon slot 6" },
        { "<leader>hx", desc = "Harpoon slot 7" },
        { "<leader>hc", desc = "Harpoon slot 8" },
        { "<leader>hv", desc = "Harpoon slot 9" },
        { "<leader>hb", desc = "Harpoon slot 10" },
        { "<leader>fh", desc = "Picker Harpoon Files" },
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        })

        vim.keymap.set("n", "<leader>aa", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                title = " Harpoon ",
                border = "rounded",
                title_pos = "center",
                ui_width_ratio = 0.40,
            })
        end)

        vim.keymap.set("n", "<leader>ha", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>hs", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>hd", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>hf", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hg", function() harpoon:list():select(5) end)
        vim.keymap.set("n", "<leader>hz", function() harpoon:list():select(6) end)
        vim.keymap.set("n", "<leader>hx", function() harpoon:list():select(7) end)
        vim.keymap.set("n", "<leader>hc", function() harpoon:list():select(8) end)
        vim.keymap.set("n", "<leader>hv", function() harpoon:list():select(9) end)
        vim.keymap.set("n", "<leader>hb", function() harpoon:list():select(10) end)

        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set('n', '<C-v>', function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set('n', '<C-x>', function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr })
            end,
        })

        local function generate_harpoon_picker()
            local file_paths = {}
            for _, item in ipairs(harpoon:list().items) do
                table.insert(file_paths, {
                    text = item.value,
                    file = item.value,
                })
            end
            return file_paths
        end

        vim.keymap.set("n", "<leader>fh", function()
            Snacks.picker({
                finder = generate_harpoon_picker,
                win = {
                    input = {
                        keys = {
                            ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                        },
                    },
                    list = {
                        keys = {
                            ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                        },
                    },
                },
                actions = {
                    harpoon_delete = function(picker, item)
                        local to_remove = item or picker:selected()
                        table.remove(harpoon:list().items, to_remove.idx)
                        picker:find({
                            refresh = true, -- refresh picker after removing values
                        })
                    end,
                },
            })
        end, { desc = "Picker Harpoon Files" })
    end,
}
