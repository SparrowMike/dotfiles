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
		lazy = false,
		config = function()
			vim.keymap.set("i", "<C-h>", "<C-o><cmd>TmuxNavigateLeft<cr>")
			vim.keymap.set("i", "<C-j>", "<C-o><cmd>TmuxNavigateDown<cr>")
			vim.keymap.set("i", "<C-k>", "<C-o><cmd>TmuxNavigateUp<cr>")
			vim.keymap.set("i", "<C-l>", "<C-o><cmd>TmuxNavigateRight<cr>")

			vim.keymap.set("v", "<C-h>", "<Esc><cmd>TmuxNavigateLeft<cr>")
			vim.keymap.set("v", "<C-j>", "<Esc><cmd>TmuxNavigateDown<cr>")
			vim.keymap.set("v", "<C-k>", "<Esc><cmd>TmuxNavigateUp<cr>")
			vim.keymap.set("v", "<C-l>", "<Esc><cmd>TmuxNavigateRight<cr>")

			vim.keymap.set("t", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>")
			vim.keymap.set("t", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>")
			vim.keymap.set("t", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>")
			vim.keymap.set("t", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>")
		end,
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
	{
		"declancm/cinnamon.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			-- default_keymaps = true,
			-- extra_keymaps = true,
			-- extended_keymaps = true,
			-- centered = true,
		},
	},
	{
		"gen740/SmoothCursor.nvim",
		event = "VeryLazy",
		config = function()
			require("smoothcursor").setup({
				type = "matrix",
				cursor = "",
				texthl = "SmoothCursor",
				linehl = nil,
				fancy = {
					enable = true,
					head = { cursor = "", texthl = "SmoothCursor", linehl = nil },
					body = {
						{ cursor = "", texthl = "SmoothCursorGreen" },
						{ cursor = "", texthl = "SmoothCursorGreen" },
						{ cursor = "●", texthl = "SmoothCursorGreen" },
						{ cursor = "●", texthl = "SmoothCursorGreen" },
						{ cursor = "•", texthl = "SmoothCursorGreen" },
						{ cursor = ".", texthl = "SmoothCursorGreen" },
						{ cursor = ".", texthl = "SmoothCursorGreen" },
					},
					tail = { cursor = nil, texthl = "SmoothCursor" },
				},
				matrix = {
					head = {
						cursor = require("smoothcursor.matrix_chars"),
						texthl = {
							"SmoothCursor",
						},
						linehl = nil,
					},
					body = {
						length = 6,
						cursor = require("smoothcursor.matrix_chars"),
						texthl = {
							"SmoothCursorGreen",
						},
					},
					tail = {
						cursor = nil,
						texthl = {
							"SmoothCursor",
						},
					},
					unstop = false,
				},
				autostart = true,
				speed = 25,
				intervals = 35,
				priority = 10,
				timeout = 3000,
				threshold = 3,
				disable_float_win = false,
				enabled_filetypes = nil,
				disabled_filetypes = { "neo-tree", "harpoon" },
			})
		end,
	}
	-- {
	-- 	"sunjon/Shade.nvim",
	-- 	config = function()
	-- 		require("shade").setup({
	-- 			overlay_opacity = 50,
	-- 			opacity_step = 1,
	-- 			keys = {
	-- 				brightness_up = "<C-Up>",
	-- 				brightness_down = "<C-Down>",
	-- 				toggle = "<Leader>s",
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
