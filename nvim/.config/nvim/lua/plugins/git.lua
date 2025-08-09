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
				delay = 500,
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
			{ "<leader>gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Compare with main" },
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
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		config = function()
			vim.g.skip_ts_context_commentstring_module = true
			vim.g.gitblame_display_virtual_text = 0
			vim.keymap.set("n", "<leader>gto", "<cmd>GitBlameOpenCommitURL<cr>")
			-- vim.keymap.set("n", "<leader>gtb", "<cmd>GitBlameToggle<cr>")
		end,
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			-- vim.keymap.set("n", "<leader>gts", ":vert Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gtd", ":Gdiffsplit<CR>", { desc = "Git diff" }) -- Updated from deprecated Gvdiff
			-- vim.keymap.set("n", "<leader>gtc", ":Git commit<CR>", { desc = "Git commit" })
			-- vim.keymap.set("n", "<leader>gtb", ":Git_blame<CR>", { desc = "Git blame" }) -- Updated to new syntax
			-- vim.keymap.set("n", "<leader>gtp", ":Git push<CR>", { desc = "Git push" })
			-- vim.keymap.set("n", "<leader>gtl", ":Git pull<CR>", { desc = "Git pull" })
			-- vim.keymap.set("n", "<leader>gtL", ":Git log<CR>", { desc = "Git log" })
			-- vim.keymap.set("n", "<leader>gtw", ":Gwrite<CR>", { desc = "Git write (add) current file" })
		end,
	},
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
				local handle = io.popen("git worktree list --porcelain")
				if not handle then
					return {}
				end

				local output = handle:read("*a")
				handle:close()

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

				local current_handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
				local current_path = current_handle and current_handle:read("*a"):gsub("\n", "") or ""
				if current_handle then
					current_handle:close()
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
							local cmd = force and "git worktree remove --force " or "git worktree remove "
							local result = vim.fn.system(cmd .. vim.fn.shellescape(selected_wt.path))

							if vim.v.shell_error == 0 then
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
											vim.fn.system("git branch -D " .. vim.fn.shellescape(selected_wt.branch))
											vim.notify("Branch deleted: " .. selected_wt.branch, vim.log.levels.INFO)
										end
									end)
								end
							else
								vim.notify("Failed to delete worktree: " .. result, vim.log.levels.ERROR)
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
