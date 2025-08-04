return {
	-- Main Treesitter plugin
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Function to disable highlighting for large files
			local function disable_for_large_files(lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end

			-- Treesitter configuration
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
					disable = disable_for_large_files,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},

	-- Treesitter context plugin
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre", -- Lazy-load on buffer read
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

	-- Treesitter playground plugin
	{
		"nvim-treesitter/playground",
		-- cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }, -- Lazy-load on commands
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- Autotag configuration
			require("nvim-ts-autotag").setup({
				enable = true,
				filetypes = { "html", "xml", "tsx" },
			})
		end,
	},
}
