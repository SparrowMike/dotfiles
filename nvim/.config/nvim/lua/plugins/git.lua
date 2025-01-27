return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			-- Basic operations with 'gt' prefix
			vim.keymap.set("n", "<leader>gts", ":vert Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gtd", ":Gdiffsplit<CR>", { desc = "Git diff" }) -- Updated from deprecated Gvdiff
			vim.keymap.set("n", "<leader>gtc", ":Git commit<CR>", { desc = "Git commit" })
			vim.keymap.set("n", "<leader>gtb", ":Git_blame<CR>", { desc = "Git blame" }) -- Updated to new syntax
			vim.keymap.set("n", "<leader>gtp", ":Git push<CR>", { desc = "Git push" })
			vim.keymap.set("n", "<leader>gtl", ":Git pull<CR>", { desc = "Git pull" })
			vim.keymap.set("n", "<leader>gtL", ":Git log<CR>", { desc = "Git log" })
			vim.keymap.set("n", "<leader>gtw", ":Gwrite<CR>", { desc = "Git write (add) current file" })

			-- Rebase operations
			vim.keymap.set("n", "<leader>gtri", ":Git rebase -i<CR>", { desc = "Git interactive rebase" })
			vim.keymap.set("n", "<leader>gtrc", ":Git rebase --continue<CR>", { desc = "Git rebase continue" })
			vim.keymap.set("n", "<leader>gtra", ":Git rebase --abort<CR>", { desc = "Git rebase abort" })

			-- Stash operations
			vim.keymap.set("n", "<leader>gtst", ":Git stash<CR>", { desc = "Git stash" })
			vim.keymap.set("n", "<leader>gtsp", ":Git stash pop<CR>", { desc = "Git stash pop" })

			-- Branch operations
			vim.keymap.set("n", "<leader>gtco", ":Git checkout<Space>", { desc = "Git checkout" })
			vim.keymap.set("n", "<leader>gtcb", ":Git checkout -b<Space>", { desc = "Git checkout new branch" })

			-- Staging operations
			vim.keymap.set("n", "<leader>gta", ":Git add -p<CR>", { desc = "Git add patch" })
			vim.keymap.set("n", "<leader>gtrs", ":Git reset -p<CR>", { desc = "Git reset patch" })

			-- Browser integration (if you have rhubarb.vim installed)
			-- vim.keymap.set("n", "<leader>gtB", ":GBrowse<CR>", { desc = "Open in browser" })
			-- vim.keymap.set("v", "<leader>gtB", ":GBrowse<CR>", { desc = "Open selection in browser" })

			-- Auto commands for the fugitive buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "fugitive",
				callback = function()
					local opts = { buffer = true, noremap = true }
					-- Stage/unstage
					vim.keymap.set("n", "s", ":Git add %<CR>", vim.tbl_extend("force", opts, { desc = "Stage file" }))
					vim.keymap.set(
						"n",
						"u",
						":Git reset -q %<CR>",
						vim.tbl_extend("force", opts, { desc = "Unstage file" })
					)
					vim.keymap.set(
						"n",
						"-",
						"<CMD>silent Git toggle<CR>",
						vim.tbl_extend("force", opts, { desc = "Stage/unstage file" })
					)

					-- File navigation
					vim.keymap.set("n", "<CR>", "gO", vim.tbl_extend("force", opts, { desc = "Open file" }))
					vim.keymap.set("n", "o", "<CR>", vim.tbl_extend("force", opts, { desc = "Open file in split" }))
					vim.keymap.set(
						"n",
						"gO",
						"<CMD>Git difftool<CR>",
						vim.tbl_extend("force", opts, { desc = "Open diff tool" })
					)

					-- Diff and commit
					vim.keymap.set("n", "dd", ":Gdiffsplit<CR>", vim.tbl_extend("force", opts, { desc = "Diff split" }))
					vim.keymap.set("n", "cc", ":Git commit<CR>", vim.tbl_extend("force", opts, { desc = "Commit" }))
					vim.keymap.set(
						"n",
						"ca",
						":Git commit --amend<CR>",
						vim.tbl_extend("force", opts, { desc = "Amend commit" })
					)

					-- Inline diff
					vim.keymap.set(
						"n",
						"=",
						"<CMD>silent Git toggle<CR>",
						vim.tbl_extend("force", opts, { desc = "Toggle inline diff" })
					)

					-- Reset and help
					vim.keymap.set(
						"n",
						"X",
						"<CMD>Git clean -fd<CR>",
						vim.tbl_extend("force", opts, { desc = "Clean untracked files" })
					)
					vim.keymap.set("n", "?", "gh?", vim.tbl_extend("force", opts, { desc = "Show keymaps" }))
				end,
			})

			-- Optional: Add statusline integration
			-- vim.opt.statusline = vim.opt.statusline + '%{FugitiveStatusline()}'
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")

			vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
			vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>:q<CR>]], { noremap = true, silent = true })
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
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})

			-- vim.keymap.set("n", "<leader>gtp", ":Gitsigns preview_hunk<CR>")
			-- vim.keymap.set("n", "<leader>gta", ":Gitsigns stage_hunk<CR>")
			-- vim.keymap.set("n", "<leader>gtu", ":Gitsigns undo_stage_hunk<CR>")
			-- vim.keymap.set("n", "<leader>gtr", ":Gitsigns reset_hunk<CR>")
			-- vim.keymap.set("n", "<leader>gtb", ":Gitsigns blame_line<CR>")
		end,
	},
}
