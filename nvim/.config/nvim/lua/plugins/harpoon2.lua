-- https://github.com/ThePrimeagen/harpoon/blob/0378a6c428a0bed6a2781d459d7943843f374bce/lua/harpoon/ui.lua

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        local toggle_opts = {
            title = " Harpoon ",
            border = "rounded",
            title_pos = "center",
            ui_width_ratio = 0.40,
        }

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
        end)

        vim.keymap.set("n", "<leader>ha", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>hs", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>hd", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>hf", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hg", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hz", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hx", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hc", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hv", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>hb", function() harpoon:list():select(4) end)

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
