return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
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
}
