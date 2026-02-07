-- return {
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		-- branch = "master",
-- 		build = ":TSUpdate",
-- 		lazy = false,
-- 		config = function()
-- 			local ts = require("nvim-treesitter")
--
-- 			ts.setup({
-- 				install_dir = vim.fn.stdpath("data") .. "/site",
-- 			})
--
-- 			local parsers = {
-- 				"lua",
-- 				"typescript",
-- 				"javascript",
-- 				"tsx",
-- 				"html",
-- 				"css",
-- 				"markdown",
-- 				"markdown_inline",
-- 			}
--
-- 			require("nvim-treesitter.install").install(parsers)
--
-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = parsers,
-- 				callback = function()
-- 					vim.treesitter.start()
-- 				end,
-- 			})
--
-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = parsers,
-- 				callback = function()
-- 					vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
-- 				end,
-- 			})
--
-- 			-- MANUALLY ENABLE FOLDING
-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = parsers,
-- 				callback = function()
-- 					vim.wo.foldmethod = "expr"
-- 					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 					vim.wo.foldenable = false -- Start with folds open
-- 				end,
-- 			})
-- 		end,
-- 	},
--
-- 	{
-- 		"nvim-treesitter/nvim-treesitter-context",
-- 		dependencis = { "nvim-treesitter/nvim-treesitter" },
-- 		event = "BufReadPre",
-- 		config = function()
-- 			require("treesitter-context").setup({
-- 				enable = true,
-- 				max_lines = 0,
-- 				min_window_height = 0,
-- 				line_numbers = true,
-- 				multiline_threshold = 5,
-- 				trim_scope = "outer",
-- 				mode = "cursor",
-- 			})
-- 		end,
-- 	},
--
-- 	{
-- 		"windwp/nvim-ts-autotag",
-- 		event = "InsertEnter",
-- 		dependencies = { "nvim-treesitter/nvim-treesitter" },
-- 		opts = {
-- 			enable = true,
-- 			filetypes = { "html", "xml", "tsx", "javascriptreact", "typescriptreact" },
-- 		},
-- 	},
-- }

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
