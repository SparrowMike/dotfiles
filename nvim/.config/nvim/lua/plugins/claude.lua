return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		auto_start = true,
		log_level = "info",
		port_range = { min = 10000, max = 65535 },
		terminal_cmd = nil,
		track_selection = true,
		visual_demotion_delay_ms = 50,
		diff_provider = "auto",
		diff_opts = {
			auto_close_on_accept = true,
			show_diff_stats = true,
			vertical_split = true,
			open_in_current_tab = true,
		},
		terminal = {
			split_side = "right",
			split_width_percentage = 0.30,
			provider = "auto",
			auto_close = true,
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", mode = { "n", "v" }, desc = "Toggle Claude Terminal" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude Code" },
		{ "<leader>co", "<cmd>ClaudeCodeOpen<cr>", mode = { "n", "v" }, desc = "Open/Focus Claude Terminal" },
		{ "<leader>cx", "<cmd>ClaudeCodeClose<cr>", mode = { "n", "v" }, desc = "Close Claude Terminal" },
		{ "<leader>cf", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{
			"<C-f>",
			"<cmd>ClaudeCode<cr>",
			mode = { "n", "i", "t" },
			desc = "Toggle Claude",
		},
	},

	config = true,
}
