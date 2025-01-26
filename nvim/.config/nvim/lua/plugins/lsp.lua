return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            -- Disable virtual_text by default
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = true,
                update_in_insert = false, -- Disable updates while typing
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            -- Toggle diagnostics
            vim.api.nvim_create_user_command("ToggleDiagnostics", function()
                local current = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({
                    virtual_text = not current,
                    underline = true,
                    signs = true,
                })
            end, {})

            -- Optimized hover handler
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover,
                {
                    border = "rounded",
                    max_width = 80, -- Adjust based on screen size
                    max_height = 20,
                    focusable = true,
                }
            )

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                -- Keybindings
                vim.keymap.set("n", "gd", function()
                    vim.lsp.buf.definition({ on_list = custom_on_list })
                end, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

                -- Document highlighting (if supported)
                if client.server_capabilities.documentHighlightProvider then
                    local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = group,
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        group = group,
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end)

            -- LSP server configurations
            require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())
            require("lspconfig").ts_ls.setup({
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                },
            })
            require("lspconfig").emmet_ls.setup({
                filetypes = { "html", "css", "javascript", "javascriptreact", "typescriptreact" },
            })
        end,
    },
}
