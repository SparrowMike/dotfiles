return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = {
		{ "<C-B>", desc = "Neo-tree filesystem" },
		{ "<C-G>", desc = "Neo-tree git status" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"s1n7ax/nvim-window-picker",
		version = "3.x",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					bo = {
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	opts = function(_, opts)
		local function on_move(data)
			Snacks.rename.on_rename_file(data.source, data.destination)
		end
		local events = require("neo-tree.events")
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})
	end,
	config = function()
		local config = require("neo-tree")
		config.setup({
			enable_git_status = true,
			enable_diagnostics = true,
			auto_clean_after_session_restore = true,
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function(arg)
						vim.cmd([[setlocal relativenumber]])
					end,
				},
			},
			window = {
				position = "right",
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					hide_dotfiles = false,
				},
			},
		})

		vim.keymap.set("n", "<C-B>", function()
			require("neo-tree.command").execute({ source = "filesystem", toggle = true, position = "right" })
		end)
		vim.keymap.set("n", "<C-G>", function()
			require("neo-tree.command").execute({ toggle = true, source = "git_status", position = "float" })
		end)
	end,
}
