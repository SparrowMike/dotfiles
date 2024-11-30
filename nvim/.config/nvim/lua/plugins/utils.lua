return {
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "Pocco81/auto-save.nvim",
    event = "BufReadPost",
    config = function()
      require("auto-save").setup({
        -- your config goes here
        -- or just leave it empty :)
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = true,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })

      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    end,
  },
  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- {
  --   "m4xshen/hardtime.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- {
  --   "tris203/precognition.nvim",
  --   event = "VeryLazy",
  --   config = {},
  -- },
  -- {
  --     'edluffy/hologram.nvim',
  --     config = function()
  --         require('hologram').setup({
  --             auto_disable = true,
  --         })
  --     end,
  -- }

  {
    "luckasRanarison/tailwind-tools.nvim",
    event = "BufRead",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = "cd app && yarn install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  --   keys = {
  --     {
  --       "<leader>mp",
  --       "<cmd>MarkdownPreview<cr>",
  --     },
  --   },
  -- },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      show_help = true,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        -- Prints debug information
        show_success_message = true,

        -- Prompt for return type and function parameters
        -- Useful for TypeScript
        prompt_func_return_type = {
          javascript = false,
          typescript = true,
        },
        prompt_func_param_type = {
          javascript = false,
          typescript = true,
        },

        -- printf_statements for console.log
        printf_statements = {
          -- For JS/TS, use console.log
          javascript = {
            'console.log("[DEBUG] %s", %s)',
          },
          typescript = {
            'console.log("[DEBUG] %s", %s)',
          },
        },

        -- Print variable debugging
        print_var_statements = {
          javascript = {
            'console.log("[DEBUG VAR] %s:", %s);',
          },
          typescript = {
            'console.log("[DEBUG VAR] %s:", %s);',
          },
        },
      })

      -- Remaps for the refactoring operations
      vim.keymap.set({ "n", "x" }, "<leader>rr", function()
        require("telescope").extensions.refactoring.refactors()
      end, { desc = "Refactor options" })

      -- Extract function supports only visual mode
      vim.keymap.set("x", "<leader>re", function()
        require("refactoring").refactor("Extract Function")
      end, { desc = "Extract function" })

      -- Extract function to file supports only visual mode
      vim.keymap.set("x", "<leader>rf", function()
        require("refactoring").refactor("Extract Function To File")
      end, { desc = "Extract function to file" })

      -- Extract variable supports only visual mode
      vim.keymap.set("x", "<leader>rv", function()
        require("refactoring").refactor("Extract Variable")
      end, { desc = "Extract variable" })

      -- Inline variable supports both normal and visual mode
      vim.keymap.set({ "n", "x" }, "<leader>ri", function()
        require("refactoring").refactor("Inline Variable")
      end, { desc = "Inline variable" })

      -- Inline function supports only normal mode
      vim.keymap.set("n", "<leader>rI", function()
        require("refactoring").refactor("Inline Function")
      end, { desc = "Inline function" })

      -- Extract block supports only normal mode
      vim.keymap.set("n", "<leader>rb", function()
        require("refactoring").refactor("Extract Block")
      end, { desc = "Extract block" })

      -- Extract block to file supports only normal mode
      vim.keymap.set("n", "<leader>rbf", function()
        require("refactoring").refactor("Extract Block To File")
      end, { desc = "Extract block to file" })

      -- Debug operations
      -- Print function call
      vim.keymap.set("n", "<leader>rp", function()
        require("refactoring").debug.printf({ below = false })
      end, { desc = "Debug print function" })

      -- Print variable
      vim.keymap.set({ "x", "n" }, "<leader>rv", function()
        require("refactoring").debug.print_var()
      end, { desc = "Debug print variable" })

      -- Clean up debug prints
      vim.keymap.set("n", "<leader>rc", function()
        require("refactoring").debug.cleanup({})
      end, { desc = "Clean up debug prints" })
    end,
  },
}
