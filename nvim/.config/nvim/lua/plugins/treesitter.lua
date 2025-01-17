return {
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-context",
	{
		"nvim-treesitter/playground",
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-ts-autotag").setup({
				enable = true,
				filetypes = { "html", "xml", "tsx" },
			})

			local config = require("nvim-treesitter.configs")
			config.setup({
				ensure_installed = {
					"lua",
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
				},
				auto_install = true,
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },

				-- enable nvim-ts-autotag
				autotag = {
					enable = false,
				},
			})
		end,
	},
}
