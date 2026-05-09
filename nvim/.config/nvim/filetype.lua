vim.filetype.add({
	extension = {
		inc = "c",
		ghostty = "ghostty",
	},
	pattern = {
		[".*/ghostty/config"] = "ghostty",
		[".*/%.ghostty/config"] = "ghostty",
		[".*/ghostty/themes/.*"] = "ghostty",
	},
})
