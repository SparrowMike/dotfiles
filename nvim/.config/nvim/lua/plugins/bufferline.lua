return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				mode = "tabs",
				numbers = "ordinal",
				indicator = {
					icon = "▎",
					style = "icon",
				},
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. n .. sym
					end
					return s
				end,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				always_show_bufferline = false,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		})

		-- Tab management
		vim.keymap.set("n", "<leader>to", ":tabnew<CR>", { noremap = true, silent = true, desc = "Open new tab" })
		vim.keymap.set(
			"n",
			"<leader>tc",
			":tabclose<CR>",
			{ noremap = true, silent = true, desc = "Close current tab" }
		)
		vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true, desc = "Previous tab" })
		vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })

		for i = 1, 9 do
			vim.keymap.set("n", "<leader>" .. i, i .. "gt", {
				noremap = true,
				silent = true,
				desc = "Go to tab " .. i,
			})
		end
	end,
}
