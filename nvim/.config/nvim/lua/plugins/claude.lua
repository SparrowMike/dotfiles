return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		auto_start = true,
		terminal = {
			split_side = "right",
			split_width_percentage = 0.30,
			provider = "snacks",
		},
		diff_opts = {
			auto_close_on_accept = true,
			vertical_split = true,
			open_in_current_tab = true,
		},
	},
	keys = {
		-- Core commands
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", mode = { "n", "v" }, desc = "Toggle Claude Terminal" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude Code" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },

		-- Diff management (when in diff mode)
		{ "<leader>da", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept all changes" },
		{ "<leader>dq", "<cmd>ClaudeCodeDiffQuit<cr>", desc = "Quit diff mode" },

		-- Terminal focus toggle
		{
			"<C-f>",
			function()
				-- Smart focus toggle
				local current_buf = vim.api.nvim_get_current_buf()
				local current_buftype = vim.bo[current_buf].buftype

				if current_buftype == "terminal" then
					vim.cmd("wincmd p")
				else
					vim.cmd("ClaudeCodeOpen")
				end
			end,
			mode = { "n", "i", "t" },
			desc = "Toggle Claude focus",
		},

		{ "<leader>cf", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
	},
	config = function(_, opts)
		require("claudecode").setup(opts)
	end,
}
