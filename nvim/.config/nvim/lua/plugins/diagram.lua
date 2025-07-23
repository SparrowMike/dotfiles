return {
	{
		"3rd/image.nvim",
		build = false,
		priority = 1000,
		lazy = false,
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					download_remote_images = true,
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = {
					enabled = true,
					download_remote_images = true,
					filetypes = { "norg" },
				},
			},
			max_width_window_percentage = 100,
			max_height_window_percentage = 100,
			kitty_method = "normal",
		},
		config = function(_, opts)
			require("image").setup(opts)
		end,
	},

	{
		"3rd/diagram.nvim",
		dependencies = { "3rd/image.nvim" },
		ft = { "markdown", "norg" },
		config = function()
			require("diagram").setup({
				integrations = {
					require("diagram.integrations.markdown"),
					require("diagram.integrations.neorg"),
				},
				events = {
					render_buffer = { "BufWinEnter", "TextChanged", "InsertLeave" },
					clear_buffer = { "BufLeave" },
				},
				renderer_options = {
					mermaid = {
						background = "transparent",
						theme = "dark",
						scale = 1,
						width = nil,
						height = nil,
					},
				},
			})
		end,
	},
}
