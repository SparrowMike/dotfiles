return {
	"ghostty",
	dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "ghostty",
			callback = function()
				vim.bo.commentstring = "# %s"
			end,
		})
	end,
}
