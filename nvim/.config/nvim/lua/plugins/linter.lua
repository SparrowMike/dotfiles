return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        local eslint = require("none-ls.diagnostics.eslint")
        local eslint_actions = require("none-ls.code_actions.eslint")

        null_ls.setup({
            sources = {
                -- Prettier config
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                        "vue",
                        "css",
                        "scss",
                        "less",
                        "html",
                        "json",
                        "jsonc",
                        "yaml",
                        "markdown",
                        "markdown.mdx",
                        "handlebars",
                    },
                }),
                null_ls.builtins.formatting.stylua,
                eslint,
                eslint_actions,
            },
            debug = false,
        })

        -- 🌟 Format Buffer and Sort Tailwind Classes
        vim.keymap.set("n", "<leader>ll", function()
            vim.lsp.buf.format({ async = true })
            local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
            for _, client in ipairs(clients) do
                if client.name == "tailwindcss" then
                    vim.cmd("TailwindSort")
                    return
                end
            end
        end, { desc = "Format buffer and optionally Tailwind sort" })

        vim.keymap.set("v", "<leader>st", function()
            -- Use visual selection with TailwindSortSelection
            vim.cmd("'<,'>TailwindSortSelection")
        end, { desc = "Sort Tailwind classes in the selected text" })

        vim.keymap.set("n", "<leader>st", function()
            -- Use TailwindSort in normal mode
            vim.cmd("TailwindSort")
        end, { desc = "Sort Tailwind classes in the buffer" })
    end,
}
