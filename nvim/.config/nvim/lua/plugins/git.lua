return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged_enable = true,
			signcolumn = true,
			word_diff = false,

			-- Git directory watching
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,

			-- Current line blame
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1500,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			-- Performance
			update_debounce = 100,
			max_file_length = 40000,

			-- Preview window
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>gv",
				function()
					local lib = require("diffview.lib")
					if lib.get_current_view() then
						vim.cmd("DiffviewClose")
					else
						vim.cmd("DiffviewOpen")
					end
				end,
				desc = "Toggle Diffview",
			},
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
			{ "<leader>gh", "<cmd>'<,'>DiffviewFileHistory<cr>", mode = "v", desc = "File History (selection)" },
			{ "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
			{
				"<leader>gm",
				function()
					Snacks.picker.git_branches({
						confirm = function(picker, item)
							picker:close()
							vim.cmd("DiffviewOpen " .. vim.trim(item.text) .. "...HEAD")
						end,
					})
				end,
				desc = "Compare with branch",
			},
		},
		config = function()
			local actions = require("diffview.actions")

			require("diffview").setup({
				enhanced_diff_hl = true,

				view = {
					default = {
						winbar_info = true,
					},
					merge_tool = {
						winbar_info = true,
					},
				},

				file_panel = {
					win_config = {
						width = 40, -- Same width as neo-tree for consistency
					},
				},

				hooks = {
					diff_buf_read = function(bufnr)
						vim.opt_local.wrap = false
						vim.opt_local.list = false
						vim.opt_local.colorcolumn = ""
					end,

					-- Auto-close neo-tree when diffview opens
					view_opened = function()
						-- Close neo-tree to avoid conflict
						pcall(function()
							vim.cmd("Neotree close")
						end)
					end,

					-- Optionally restore neo-tree when diffview closes
					view_closed = function()
						-- Uncomment if you want neo-tree to auto-open when diffview closes
						-- vim.defer_fn(function()
						-- 	vim.cmd("Neotree filesystem show")
						-- end, 100)
					end,
				},

				keymaps = {
					view = {
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
						-- Use C-B to focus the file panel (not toggle)
						{ "n", "<C-b>", actions.focus_files, { desc = "Focus file panel" } },
						{ "n", "co", actions.conflict_choose("ours"), { desc = "Take ours" } },
						{ "n", "ct", actions.conflict_choose("theirs"), { desc = "Take theirs" } },
						{ "n", "cb", actions.conflict_choose("base"), { desc = "Take base" } },
					},
					file_panel = {
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
						-- C-B to return focus to diff view
						{
							"n",
							"<C-b>",
							function()
								vim.cmd("wincmd l")
							end,
							{ desc = "Focus diff view" },
						},
					},
					file_history_panel = {
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
						-- C-B to focus back to diff view
						{
							"n",
							"<C-b>",
							function()
								vim.cmd("wincmd l")
							end,
							{ desc = "Focus diff view" },
						},
					},
				},
			})

			vim.opt.fillchars:append({ diff = "╱" })
		end,
	},
	-- {
	-- 	"f-person/git-blame.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		vim.g.skip_ts_context_commentstring_module = true
	-- 		vim.g.gitblame_display_virtual_text = 0
	-- 		vim.keymap.set("n", "<leader>gto", "<cmd>GitBlameOpenCommitURL<cr>")
	-- 		-- vim.keymap.set("n", "<leader>gtb", "<cmd>GitBlameToggle<cr>")
	-- 	end,
	-- },
	{
		"Juksuu/worktrees.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("worktrees").setup({
				log_level = vim.log.levels.WARN,
				log_status = true,
			})

			local worktree_utils = {}

			-- Get list of worktrees (used internally by delete)
			local function get_worktrees()
				-- Use vim.system with timeout instead of blocking io.popen
				local result = vim.system({
					"git", "worktree", "list", "--porcelain"
				}, {
					text = true,
					timeout = 5000  -- 5 second timeout
				}):wait()

				if result.code ~= 0 then
					-- Command failed or timed out
					vim.notify("Failed to get worktrees: " .. (result.stderr or "command failed"), vim.log.levels.WARN)
					return {}
				end

				local output = result.stdout
				local worktrees = {}
				local current = {}

				for line in output:gmatch("[^\r\n]+") do
					if line:match("^worktree ") then
						if current.path then
							table.insert(worktrees, current)
						end
						current = { path = line:match("^worktree (.+)") }
					elseif line:match("^HEAD ") then
						current.head = line:match("^HEAD (.+)")
					elseif line:match("^branch ") then
						current.branch = line:match("^branch (.+)")
					elseif line:match("^detached$") then
						current.detached = true
					end
				end

				if current.path then
					table.insert(worktrees, current)
				end

				return worktrees
			end

			-- Delete worktree with branch cleanup (this is genuinely useful)
			function worktree_utils.delete_worktree(force)
				local worktrees = get_worktrees()
				if #worktrees <= 1 then
					vim.notify("No worktrees to delete", vim.log.levels.WARN)
					return
				end

				-- Use vim.system with timeout instead of blocking io.popen
				local result = vim.system({
					"git", "rev-parse", "--show-toplevel"
				}, {
					text = true,
					timeout = 3000  -- 3 second timeout
				}):wait()
				local current_path = ""
				if result.code == 0 and result.stdout then
					current_path = result.stdout:gsub("\n", "")
				end

				local choices = {}
				local worktree_map = {}
				for _, wt in ipairs(worktrees) do
					if not wt.path:match("%.git$") then
						local name = wt.path:match("([^/]+)$") or wt.path
						local branch = wt.branch or wt.head or "detached"
						local current = wt.path == current_path and " (current)" or ""
						local choice = string.format("%s [%s]%s", name, branch, current)
						table.insert(choices, choice)
						worktree_map[choice] = wt
					end
				end

				vim.ui.select(choices, {
					prompt = force and "Force delete worktree:" or "Delete worktree:",
				}, function(choice)
					if not choice then
						return
					end

					local selected_wt = worktree_map[choice]
					if not selected_wt then
						return
					end

					if selected_wt.path == current_path then
						vim.notify("Cannot delete current worktree. Switch first.", vim.log.levels.ERROR)
						return
					end

					local confirm_msg =
						string.format("Delete worktree '%s'? (y/n): ", selected_wt.path:match("([^/]+)$"))
					vim.ui.input({ prompt = confirm_msg }, function(input)
						if input and input:lower() == "y" then
							-- Use vim.system with timeout instead of blocking vim.fn.system
							local args = force and { "git", "worktree", "remove", "--force", selected_wt.path }
								or { "git", "worktree", "remove", selected_wt.path }
							local result = vim.system(args, {
								text = true,
								timeout = 10000  -- 10 second timeout for deletion
							}):wait()

							if result.code == 0 then
								vim.notify(
									"Worktree deleted: " .. selected_wt.path:match("([^/]+)$"),
									vim.log.levels.INFO
								)

								-- Offer to delete branch (only for feature branches)
								if selected_wt.branch and not selected_wt.branch:match("^(main|master|develop)$") then
									vim.ui.input({
										prompt = string.format("Also delete branch '%s'? (y/n): ", selected_wt.branch),
									}, function(branch_input)
										if branch_input and branch_input:lower() == "y" then
											-- Use vim.system with timeout instead of blocking vim.fn.system
											local branch_result = vim.system({
												"git", "branch", "-D", selected_wt.branch
											}, {
												text = true,
												timeout = 5000  -- 5 second timeout
											}):wait()

											if branch_result.code == 0 then
												vim.notify("Branch deleted: " .. selected_wt.branch, vim.log.levels.INFO)
											else
												vim.notify("Failed to delete branch: " .. (branch_result.stderr or "command failed"), vim.log.levels.WARN)
											end
										end
									end)
								end
							else
								vim.notify("Failed to delete worktree: " .. (result.stderr or "command failed"), vim.log.levels.ERROR)
							end
						end
					end)
				end)
			end

			_G.worktree_utils = worktree_utils
		end,
		keys = {
			-- Core worktree operations (using Snacks)
			{
				"<leader>gws",
				function()
					Snacks.picker.worktrees()
				end,
				desc = "Switch Worktree",
			},
			{
				"<leader>gwn",
				function()
					Snacks.picker.worktrees_new()
				end,
				desc = "New Worktree",
			},

			-- Delete operations (your custom implementation is good for branch cleanup)
			{
				"<leader>gwd",
				function()
					_G.worktree_utils.delete_worktree()
				end,
				desc = "Delete Worktree",
			},
			{
				"<leader>gwD",
				function()
					_G.worktree_utils.delete_worktree(true)
				end,
				desc = "Force Delete Worktree",
			},
		},
	},
}
