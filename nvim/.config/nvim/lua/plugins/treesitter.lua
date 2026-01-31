return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
        branch = "master",
		config = function()

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
					"norg",
					"markdown",
					"markdown_inline",
				},
				auto_install = false,
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 0,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 5,
				trim_scope = "outer",
				mode = "cursor",
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			enable = true,
			filetypes = { "html", "xml", "tsx", "javascriptreact", "typescriptreact" },
		},
	},
}
