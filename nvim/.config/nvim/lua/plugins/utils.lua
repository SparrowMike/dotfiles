return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			-- vim.g.VM_theme = "purplegray"
			-- vim.g.VM_mouse_mappings = 1
			vim.schedule(function()
				vim.g.VM_maps = {
					["I BS"] = "",
					["Goto Next"] = "",
					["Goto Prev"] = "",
				}
			end)
		end,
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
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
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
		"dstein64/vim-startuptime",
		-- lazy-load on a command
		cmd = "StartupTime",
		-- init is called during startup. Configuration for vim plugins typically should be set in an init function
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
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
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"karb94/neoscroll.nvim",
		opts = {
			duration_multiplier = 3.0,
		},
		config = function()
			local neoscroll = require("neoscroll")

			neoscroll.setup({ mappings = { "<C-u>", "<C-d>" } })

			local keymap = {
				-- Use the "sine" easing function
				["<C-u>"] = function()
					neoscroll.ctrl_u({ duration = 100, easing = "sine" })
				end,
				["<C-d>"] = function()
					neoscroll.ctrl_d({ duration = 100, easing = "sine" })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
	-- amongst your other plugins
	-- { "akinsho/toggleterm.nvim", version = "*", config = true },
	-- { "akinsho/toggleterm.nvim", version = "*", config = function() require("toggleterm").setup{} end },
	-- {
	-- 	"akinsho/toggleterm.nvim",
	-- 	version = "*",
	-- 	opts = {},
	-- },
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
}
