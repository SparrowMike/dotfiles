return {
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-context",
	{
		"nvim-treesitter/playground",
		build = ":TSUpdate",
		config = function()
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
					enable = true,
				},
			})
		end,
	},
}
