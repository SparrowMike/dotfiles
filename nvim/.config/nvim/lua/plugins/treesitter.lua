return {
    {
        "nvim-treesitter/nvim-treesitter",
        'nvim-treesitter/nvim-treesitter-context',
        'nvim-treesitter/playground',
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "css", "html", "scss" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end
    }
}

