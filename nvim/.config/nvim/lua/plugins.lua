return {
  {'mfussenegger/nvim-lint'},

  'nvim-treesitter/playground',

  'ryanoasis/vim-devicons',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',

  {
      'mg979/vim-visual-multi', 
      branch = 'master'
  },

  -- 'preservim/nerdtree',

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
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        icons = true,
        -- your configuration comes here
        -- or leave it empty to the default settings
        -- refer to the configuration section below
      }
    end
  },
  {'nvim-treesitter/nvim-treesitter-context'},
  {'mfussenegger/nvim-lint'},
}
