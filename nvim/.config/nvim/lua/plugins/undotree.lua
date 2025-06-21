return {
	"mbbill/undotree",
	config = function()
		vim.g.undotree_WindowLayout = 2 -- Vertical layout with diff at bottom
		vim.g.undotree_SplitWidth = 40 -- Width of the undo tree window
		vim.g.undotree_DiffpanelHeight = 10 -- Height of the diff panel
		vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when opened
		vim.g.undotree_ShortIndicators = 1 -- Use short time indicators
		vim.g.undotree_DiffAutoOpen = 1 -- Auto open diff panel
		vim.g.undotree_TreeNodeShape = "◦" -- Custom tree node shape
		vim.g.undotree_TreeVertShape = "│" -- Custom vertical line shape
		vim.g.undotree_TreeSplitShape = "╱" -- Custom split shape
		vim.g.undotree_TreeReturnShape = "╲" -- Custom return shape

		local opts = { noremap = true, silent = true, desc = "Undotree" }
		vim.keymap.set(
			"n",
			"<leader>uu",
			vim.cmd.UndotreeToggle,
			vim.tbl_extend("force", opts, { desc = "Toggle Undotree" })
		)
	end,
	keys = {
		{ "<leader>uu", desc = "Toggle Undotree" },
	},
}
