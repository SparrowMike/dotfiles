return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = {
		{ "<C-G>", "<cmd>Neotree git_status toggle float<cr>", desc = "Neo-tree git status" },
		{
			"<C-B>",
			function()
				-- Check if we're currently in a neo-tree buffer
				local buf_name = vim.api.nvim_buf_get_name(0)
				if buf_name:match("neo%-tree") then
					-- We're in neo-tree, close it
					vim.cmd("Neotree filesystem close")
					return
				end

				-- Smart focus: diffview focus if in diffview, otherwise neo-tree
				local diffview_lib = require("diffview.lib")
				if diffview_lib.get_current_view() then
					-- In diffview: toggle focus between file panel and diff view
					require("diffview.actions").focus_files()
				else
					vim.cmd("Neotree filesystem focus")
				end
			end,
			mode = { "n", "t" },
			desc = "Smart focus (Neo-tree or Diffview)",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
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
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.relativenumber = true
				end,
			},
		})

		return vim.tbl_deep_extend("force", opts, {
			enable_git_status = true,
			enable_diagnostics = true,
			auto_clean_after_session_restore = true,
			window = {
				position = "right",
				width = function()
				-- Calculate width with min/max constraints
				local screen_width = vim.o.columns
				local target_width = math.floor(screen_width * 0.15) -- 15% of screen
				local min_width = 40   -- Minimum 20 columns
				local max_width = math.floor(screen_width * 0.2) -- Maximum 2% of screen

				return math.max(min_width, math.min(target_width, max_width))
			end,
				mappings = {
					["<C-f>"] = false, -- Disable C-f so Claude works

					["<C-b>"] = "none",

					["o"] = function(state)
						local node = state.tree:get_node()
						if node.type == "file" then
							-- Open the file and close neo-tree
							require("neo-tree.sources.filesystem.commands").open(state)
							vim.cmd("Neotree close")
						else
							-- For directories, use default behavior (expand/collapse)
							require("neo-tree.sources.filesystem.commands").toggle_node(state)
						end
					end,
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					hide_dotfiles = false,
				},
				use_libuv_file_watcher = true,
			},
		})
	end,
}
