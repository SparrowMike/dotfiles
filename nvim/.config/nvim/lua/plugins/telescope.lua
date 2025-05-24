return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
		lazy = true,
		event = "VeryLazy",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		cmd = "Telescope",
        lazy = true,
        event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			-- Telescope setup
			telescope.setup({

				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				defaults = {
					mappings = {
						n = {
							["<C-d>"] = actions.delete_buffer,
						}, -- n
						i = {
							["<C-h>"] = "which_key",
							["<C-d>"] = actions.delete_buffer,
						},
					},
					preview = {
						treesitter = false,
					},
				},
				pickers = {
					find_files = {
						-- theme = "ivy",
					},
				},
			})

			-- Load extensions
			telescope.load_extension("ui-select")

			-- Keybindings
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Git files" })

			-- Show buffers
			vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "Show buffers" })

			-- Grep string in normal mode
			vim.keymap.set("n", "<C-f>", builtin.grep_string, { desc = "Grep string" })

			-- Grep string in visual mode
			vim.keymap.set("v", "<C-f>", function()
				local search_term = vim.fn.getreg('"')
				if search_term == "" then
					print("No text selected for grep.")
					return
				end
				builtin.grep_string({ search = search_term })
			end, { desc = "Grep selected text" })

			-- Grep input
			vim.keymap.set("n", "<leader>gf", function()
				local search_query = vim.fn.input("Grep > ")
				if search_query == "" then
					print("Empty search string provided.")
					return
				end
				builtin.grep_string({ search = search_query })
			end, { desc = "Grep input" })
		end,
	},
}
