return {
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})

			vim.keymap.set("n", "<C-s>", "<cmd>SessionSave<CR>", { desc = "Save session", silent = true })
		end,
	},
}
