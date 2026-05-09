return {
	"ghostty",
	dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
	ft = { "ghostty" },
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "ghostty",
			callback = function()
				vim.bo.commentstring = "# %s"
			end,
		})
	end,
}
