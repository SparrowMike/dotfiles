return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		port_range = { min = 10000, max = 65535 },
		auto_start = true,
		terminal = {
			provider = "snacks",
			-- split_side = "right",
			split_width_percentage = 0.30,
		},
		diff_opts = {
			-- vertical_split = true,
			auto_close_on_accept = true,
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
	},
}
