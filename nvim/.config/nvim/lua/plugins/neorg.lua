return {
	"nvim-neorg/neorg",
	lazy = false,
	version = "*",
	keys = {
		{
			"<leader>nn",
			":Neorg<CR>",
			desc = "Open Neorg",
		},
		{
			"<leader>ni",
			":Neorg index<CR>",
			desc = "Neorg index",
		},
		{
			"<leader>nr",
			":Neorg return<CR>",
			desc = "Return back from Neorg",
		},
	},
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/notes",
						},
						default_workspace = "notes",
					},
				},
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2

        vim.keymap.set("n", "<leader>nn", ":Neorg<CR>", { desc = "Open Neorg" })
	end,
}
