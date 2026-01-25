return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.opt.termguicolors = true

		require("bufferline").setup({
			options = {
				mode = "tabs",
				numbers = "ordinal",
				indicator = {
					icon = "▎", -- could also use: "⎸", "⮞", "▶", "➜"
					style = "icon",
				},
				buffer_close_icon = "",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 12,
				tab_size = 18,
				separator_style = "slant", -- "slant" | "padded_slant" | "thick" | "thin" | { 'left', 'right' }
				enforce_regular_tabs = true,
				always_show_bufferline = false,
				show_buffer_close_icons = true,
				show_close_icon = true,
				color_icons = true,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(_, _, diagnostics, _)
					local icons = {
						error = " ",
						warning = " ",
						info = " ",
						hint = "󰌵 ",
					}
					local result = {}
					for name, count in pairs(diagnostics) do
						if icons[name] and count > 0 then
							table.insert(result, string.format("%s%d", icons[name], count))
						end
					end
					return table.concat(result, " ")
				end,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = " File Explorer",
						highlight = "Directory",
						separator = true,
						text_align = "left",
					},
				},
			},
			highlights = {
				buffer_selected = {
					italic = false,
					bold = true,
				},
				tab_selected = {
					bold = true,
				},
				separator_selected = {
					-- fg = "#5e81ac",
				},
			},
		})

		-- Tab navigation
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		keymap("n", "<leader>to", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "Open new tab" }))
		keymap("n", "<leader>tc", "<cmd>tabclose<CR>", vim.tbl_extend("force", opts, { desc = "Close current tab" }))
		keymap("n", "<leader>tp", "<cmd>tabprevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous tab" }))
		keymap("n", "<leader>tn", "<cmd>tabnext<CR>", vim.tbl_extend("force", opts, { desc = "Next tab" }))

		for i = 1, 9 do
			keymap(
				"n",
				"<leader>" .. i,
				i .. "gt",
				vim.tbl_extend("force", opts, {
					desc = "Go to tab " .. i,
				})
			)
		end
	end,
}
