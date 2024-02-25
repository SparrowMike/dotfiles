return {
    {
        'mfussenegger/nvim-lint'
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master'
    },
    {
        'Pocco81/auto-save.nvim',
        config = function()
            require('auto-save').setup {
                -- your config goes here
                -- or just leave it empty :)
            }
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'windwp/nvim-ts-autotag',
    }
}
