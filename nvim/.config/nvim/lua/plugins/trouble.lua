return {
	{
		"folke/trouble.nvim",
		branch = "main",
		opts = {
			warn_no_results = true,
			open_no_results = true,
			focus = true,
			modes = {
				-- Custom references mode
				references = {
					mode = "lsp_references",
					focus = true,
					win = {
                        position = "left",
                        size = 0.15, -- %
                        min_size = 40, -- columns
                        max_size = 0.17 -- %
                    },
					filter = {
						["not"] = { kind = "definition" },
					},
				},
				-- Buffer diagnostics mode
				buffer_diagnostics = {
					mode = "diagnostics",
					filter = { buf = 0 },
				},
			},
		},
		cmd = "Trouble",
		config = function(_, opts)
			require("trouble").setup(opts)

			-- Create a smart toggle function using the new API
			local function smart_toggle(mode_config)
				local trouble = require("trouble")

				-- If it's a string, convert to table
				if type(mode_config) == "string" then
					mode_config = { mode = mode_config }
				end

				-- Check if already open
				if trouble.is_open(mode_config) then
					-- Get current window info
					local win = vim.api.nvim_get_current_win()
					local buf = vim.api.nvim_win_get_buf(win)
					local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

					if buf_ft == "trouble" then
						-- We're in trouble window, close it
						trouble.close(mode_config)
					else
						-- We're not in trouble window, focus it
						trouble.focus(mode_config)
					end
				else
					-- Not open, so open it
					trouble.open(mode_config)
				end
			end

			-- Create user commands
			vim.api.nvim_create_user_command("TroubleSmartDiagnostics", function()
				smart_toggle("diagnostics")
			end, { desc = "Smart toggle diagnostics" })

			vim.api.nvim_create_user_command("TroubleSmartBufferDiagnostics", function()
				smart_toggle("buffer_diagnostics")
			end, { desc = "Smart toggle buffer diagnostics" })

			vim.api.nvim_create_user_command("TroubleSmartSymbols", function()
				smart_toggle("symbols")
			end, { desc = "Smart toggle symbols" })

			vim.api.nvim_create_user_command("TroubleSmartReferences", function()
				smart_toggle("references")
			end, { desc = "Smart toggle references" })

			vim.api.nvim_create_user_command("TroubleSmartLsp", function()
				smart_toggle({ mode = "lsp", win = { position = "left" } })
			end, { desc = "Smart toggle LSP" })
		end,
		keys = {
			{
				"<leader>tt",
				"<cmd>TroubleSmartDiagnostics<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>TT",
				"<cmd>TroubleSmartBufferDiagnostics<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>ts",
				"<cmd>TroubleSmartSymbols<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>tr",
				"<cmd>TroubleSmartReferences<cr>",
				desc = "References (Trouble)",
			},
			{
				"<leader>tl",
				"<cmd>TroubleSmartLsp<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>tL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>tq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
