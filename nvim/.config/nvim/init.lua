local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugin =
{
  'wbthomason/packer.nvim',

  {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      -- or                            , branch = '0.1.x',
      dependencies = { {'nvim-lua/plenary.nvim'} }
  },

  {'rose-pine/neovim', name = 'rose-pine'},
  { "catppuccin/nvim", name = "catppuccin" },
  { "morhetz/gruvbox" },

  {
      'nvim-treesitter/nvim-treesitter',
      config = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end
  },

  "nvim-treesitter/playground",
  "theprimeagen/harpoon",
  "mbbill/undotree",
  "tpope/vim-fugitive",

  'ryanoasis/vim-devicons',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',

  {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      dependencies = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  },

  {
      'mg979/vim-visual-multi', 
      branch = 'master'
  },

  'github/copilot.vim',
  'lewis6991/gitsigns.nvim',

  -- 'preservim/nerdtree')
  {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = { 
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
  },

  {
      "Pocco81/auto-save.nvim",
      config = function()
         require("auto-save").setup {
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
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = true,
        -- your configuration comes here
        -- or leave it empty to the default settings
        -- refer to the configuration section below
      }
    end
  },

  "eandrju/cellular-automaton.nvim",
}

require("lazy").setup(plugin)
