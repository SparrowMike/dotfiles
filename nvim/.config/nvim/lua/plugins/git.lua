return {
	{
		"lewis6991/gitsigns.nvim",
		-- event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				-- signs = {
				-- 	add = { text = "┃" },
				-- 	change = { text = "┃" },
				-- 	delete = { text = "_" },
				-- 	topdelete = { text = "‾" },
				-- 	changedelete = { text = "~" },
				-- 	untracked = { text = "┆" },
				-- },
				-- signs_staged = {
				-- 	add = { text = "┃" },
				-- 	change = { text = "┃" },
				-- 	delete = { text = "_" },
				-- 	topdelete = { text = "‾" },
				-- 	changedelete = { text = "~" },
				-- 	untracked = { text = "┆" },
				-- },
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>" },
			{ "<leader>gc", "<cmd>DiffviewFileHistory %<cr>" },
			{ "<leader>gc", "<cmd>DiffviewFileHistory %<cr>", mode = "v" },
			{ "<leader>gx", "<cmd>DiffviewClose<cr>" },
		},
		config = function()
			local set = vim.opt -- set options
			set.fillchars = set.fillchars + "diff:╱"
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
			-- Basic operations with 'gt' prefix
			-- vim.keymap.set("n", "<leader>gts", ":vert Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gtd", ":Gdiffsplit<CR>", { desc = "Git diff" }) -- Updated from deprecated Gvdiff
			-- vim.keymap.set("n", "<leader>gtc", ":Git commit<CR>", { desc = "Git commit" })
			-- vim.keymap.set("n", "<leader>gtb", ":Git_blame<CR>", { desc = "Git blame" }) -- Updated to new syntax
			-- vim.keymap.set("n", "<leader>gtp", ":Git push<CR>", { desc = "Git push" })
			-- vim.keymap.set("n", "<leader>gtl", ":Git pull<CR>", { desc = "Git pull" })
			-- vim.keymap.set("n", "<leader>gtL", ":Git log<CR>", { desc = "Git log" })
			-- vim.keymap.set("n", "<leader>gtw", ":Gwrite<CR>", { desc = "Git write (add) current file" })

			-- Staging operations
			-- vim.keymap.set("n", "<leader>gta", ":Git add -p<CR>", { desc = "Git add patch" })
			-- vim.keymap.set("n", "<leader>gtrs", ":Git reset -p<CR>", { desc = "Git reset patch" })

			-- Auto commands for the fugitive buffer
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "fugitive",
			-- 	callback = function()
			-- 		local opts = { buffer = true, noremap = true }
			-- 		vim.keymap.set(
			-- 			"n",
			-- 			"-",
			-- 			"<CMD>silent Git toggle<CR>",
			-- 			vim.tbl_extend("force", opts, { desc = "Stage/unstage file" })
			-- 		)
			--
			-- 		-- File navigation
			-- 		vim.keymap.set(
			-- 			"n",
			-- 			"gO",
			-- 			"<CMD>Git difftool<CR>",
			-- 			vim.tbl_extend("force", opts, { desc = "Open diff tool" })
			-- 		)
			--
			-- 		-- Diff and commit
			-- 		vim.keymap.set("n", "dd", ":Gdiffsplit<CR>", vim.tbl_extend("force", opts, { desc = "Diff split" }))
			--
			-- 		-- Inline diff
			-- 		vim.keymap.set(
			-- 			"n",
			-- 			"=",
			-- 			"<CMD>silent Git toggle<CR>",
			-- 			vim.tbl_extend("force", opts, { desc = "Toggle inline diff" })
			-- 		)
			-- 	end,
			-- })
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

			-- Store utility functions in a local table
			local worktree_utils = {}

			-- Get list of worktrees
			function worktree_utils.get_worktrees()
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

			-- List all worktrees
			function worktree_utils.list_worktrees()
				local worktrees = worktree_utils.get_worktrees()
				if #worktrees == 0 then
					vim.notify("No worktrees found", vim.log.levels.INFO)
					return
				end

				local lines = { "Git Worktrees:" }
				for _, wt in ipairs(worktrees) do
					local status = wt.detached and " (detached)" or ""
					local branch = wt.branch or wt.head or "unknown"
					table.insert(lines, string.format("  %s → %s%s", wt.path, branch, status))
				end

				vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
			end

			-- Delete a worktree
			function worktree_utils.delete_worktree(force)
				local worktrees = worktree_utils.get_worktrees()
				if #worktrees <= 1 then
					vim.notify("No worktrees to delete (main worktree cannot be deleted)", vim.log.levels.WARN)
					return
				end

				-- Get current worktree path
				local current_handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
				local current_path = current_handle and current_handle:read("*a"):gsub("\n", "") or ""
				if current_handle then
					current_handle:close()
				end

				-- Create selection list (exclude main worktree)
				local choices = {}
				local worktree_map = {}
				for _, wt in ipairs(worktrees) do
					-- Skip if it's the bare repository
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

					-- Check if trying to delete current worktree
					if selected_wt.path == current_path then
						vim.notify(
							"Cannot delete current worktree. Switch to another worktree first.",
							vim.log.levels.ERROR
						)
						return
					end

					-- Confirm deletion
					local confirm_msg =
						string.format("Delete worktree '%s'? This action cannot be undone.", selected_wt.path)
					vim.ui.input({ prompt = confirm_msg .. " (y/n): " }, function(input)
						if input and input:lower() == "y" then
							local cmd = force and "git worktree remove --force " or "git worktree remove "
							local result = vim.fn.system(cmd .. vim.fn.shellescape(selected_wt.path))

							if vim.v.shell_error == 0 then
								vim.notify("Worktree deleted: " .. selected_wt.path, vim.log.levels.INFO)
								-- Also try to delete the branch if it was a feature branch
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

			-- Force delete a worktree
			function worktree_utils.force_delete_worktree()
				worktree_utils.delete_worktree(true)
			end

			-- Prune worktrees (remove references to deleted worktrees)
			function worktree_utils.prune_worktrees()
				local result = vim.fn.system("git worktree prune")
				if vim.v.shell_error == 0 then
					vim.notify("Pruned worktree references", vim.log.levels.INFO)
				else
					vim.notify("Failed to prune worktrees: " .. result, vim.log.levels.ERROR)
				end
			end

			-- Create user commands
			vim.api.nvim_create_user_command("WorktreeDelete", function()
				worktree_utils.delete_worktree()
			end, { desc = "Delete a git worktree" })

			vim.api.nvim_create_user_command("WorktreeForceDelete", function()
				worktree_utils.force_delete_worktree()
			end, { desc = "Force delete a git worktree" })

			vim.api.nvim_create_user_command("WorktreeList", function()
				worktree_utils.list_worktrees()
			end, { desc = "List all git worktrees" })

			vim.api.nvim_create_user_command("WorktreePrune", function()
				worktree_utils.prune_worktrees()
			end, { desc = "Prune deleted worktree references" })

			-- Make utilities available globally for keymaps
			_G.worktree_utils = worktree_utils
		end,
		keys = {
			-- Since you already have snacks implemented, use these keymaps
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
			-- Alternative keymaps using the plugin's native functions
			{ "<leader>gwc", "<cmd>GitWorktreeCreate<cr>", desc = "Create Worktree" },
			{
				"<leader>gwe",
				"<cmd>GitWorktreeCreateExisting<cr>",
				desc = "Create Worktree (Existing Branch)",
			},
			-- Custom delete commands
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
					_G.worktree_utils.force_delete_worktree()
				end,
				desc = "Force Delete Worktree",
			},
			{
				"<leader>gwl",
				function()
					_G.worktree_utils.list_worktrees()
				end,
				desc = "List Worktrees",
			},
			{
				"<leader>gwp",
				function()
					_G.worktree_utils.prune_worktrees()
				end,
				desc = "Prune Worktrees",
			},
		},
	},
}
