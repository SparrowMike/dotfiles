return {
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			-- vim.g.VM_theme = "purplegray"
			vim.g.VM_mouse_mappings = 1
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

				-- INFO: condition required for the harpoon2 to work
				condition = function(buf)
					local fn = vim.fn
					local utils = require("auto-save.utils.data")

					if
						fn.getbufvar(buf, "&modifiable") == 1
						-- change here is adding harpoon file type to exclusion list
						and utils.not_in(fn.getbufvar(buf, "&filetype"), { "harpoon" })
					then
						return true
					end
					return false
				end,
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
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.nvim",
		},
		ft = { "markdown" },
		config = function()
			require("render-markdown").setup({
				headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				code = {
					width = "block",
					right_pad = 1,
				},
				dash = "—",
				checkbox = {
					unchecked = { icon = "󰄱 " },
					checked = { icon = "󰱒 " },
				},
			})

			vim.keymap.set(
				"n",
				"<leader>mr",
				":RenderMarkdown toggle<CR>",
				{ desc = "Toggle markdown rendering", silent = true }
			)
		end,
	},
	-- {
	-- 	"nvzone/typr",
	-- 	dependencies = "nvzone/volt",
	-- 	opts = {},
	-- 	cmd = { "Typr", "TyprStats" },
	-- }
}
