return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui" },
			{ "nvim-neotest/nvim-nio" },
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
			},
			{ "mxsdev/nvim-dap-vscode-js" },
			{ "theHamsta/nvim-dap-virtual-text" },
		},
		commit = "7ff6936010b7222fea2caea0f67ed77f1b7c60dd",
		event = "VeryLazy",
		cmd = {
			"DapContinue",
			"DapToggleBreakpoint",
			"DapSetBreakpoint",
			"DapStepInto",
			"DapStepOver",
			"DapStepOut",
			"DapREPLOpen",
			"DapUIToggle",
			"DapTerminate",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local sign = vim.fn.sign_define

			-- Basic debug signs
			sign("DapBreakpoint", {
				text = "●", -- or "🔴" for unicode
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "DapBreakpoint",
			})

			sign("DapBreakpointCondition", {
				text = "◆", -- or "🔶" for unicode
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "DapBreakpointCondition",
			})

			sign("DapLogPoint", {
				text = "◆", -- or "📝" for unicode
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "DapLogPoint",
			})

			sign("DapStopped", {
				text = "▶", -- or "⭐" for unicode
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "DapStopped",
			})

			-- Additional useful debug signs
			sign("DapBreakpointRejected", {
				text = "●", -- or "❌" for unicode
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "DapBreakpointRejected",
			})

			sign("DapBreakpointDisabled", {
				text = "○", -- or "⭕" for unicode
				texthl = "DapBreakpointDisabled",
				linehl = "",
				numhl = "",
			})

			sign("DapCurrentLine", {
				text = "→", -- or "▶" for unicode
				texthl = "DapCurrentLine",
				linehl = "DapCurrentLine",
				numhl = "",
			})

			sign("DapCurrentFrame", {
				text = "▸", -- or "🔍" for unicode
				texthl = "DapCurrentFrame",
				linehl = "DapCurrentFrameLine",
				numhl = "",
			})

			-- Define highlight groups for all signs
			vim.cmd([[
                highlight DapBreakpoint guifg=#993939 guibg=NONE
                highlight DapBreakpointCondition guifg=#F23D3D guibg=NONE
                highlight DapLogPoint guifg=#61afef guibg=NONE
                highlight DapStopped guifg=#98c379 guibg=NONE
                highlight DapStoppedLine guibg=#31353f
                highlight DapBreakpointRejected guifg=#666666 guibg=NONE
                highlight DapBreakpointDisabled guifg=#555555 guibg=NONE
                highlight DapCurrentLine guifg=#98c379 guibg=NONE
                highlight DapCurrentFrameLine guibg=#2d3139
                highlight DapCurrentFrame guifg=#61afef guibg=NONE
            ]])

			dapui.setup({})

			-- Enhanced virtual text setup
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
				commented = false,
				virt_text_pos = "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})

			-- JavaScript/TypeScript debug configurations
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
				adapters = { "chrome", "pwa-chrome", "pwa-node", "node-terminal" },
			})

			local js_based_languages = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:3000",
								}, function(url)
									if url then
										coroutine.resume(co, url)
									end
								end)
							end)
						end,
						webRoot = "${workspaceFolder}",
						runtimeExecutable = "stable",
						sourceMaps = true,

						protocol = "inspector",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
					{
						type = "pwa-chrome",
						request = "attach",
						name = "Attach to Chrome",
						port = 9222,
						webRoot = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
				}
			end

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				vim.api.nvim_command("DapVirtualTextEnable")
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Enhanced keymaps with better descriptions
			local keymap_opts = { silent = true, noremap = true }
			vim.keymap.set(
				"n",
				"<leader>db",
				dap.toggle_breakpoint,
				vim.tbl_extend("force", keymap_opts, { desc = "Toggle Breakpoint" })
			)
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, vim.tbl_extend("force", keymap_opts, { desc = "Conditional Breakpoint" }))
			vim.keymap.set("n", "<leader>dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, vim.tbl_extend("force", keymap_opts, { desc = "Log Point" }))
			vim.keymap.set(
				"n",
				"<leader>dc",
				dap.continue,
				vim.tbl_extend("force", keymap_opts, { desc = "Continue/Start Debug" })
			)
			vim.keymap.set(
				"n",
				"<leader>di",
				dap.step_into,
				vim.tbl_extend("force", keymap_opts, { desc = "Step Into" })
			)
			vim.keymap.set(
				"n",
				"<leader>do",
				dap.step_over,
				vim.tbl_extend("force", keymap_opts, { desc = "Step Over" })
			)
			vim.keymap.set("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", keymap_opts, { desc = "Step Out" }))

			vim.keymap.set(
				"n",
				"<leader>dr",
				dap.repl.open,
				vim.tbl_extend("force", keymap_opts, { desc = "Open REPL" })
			)
			vim.keymap.set(
				"n",
				"<leader>du",
				dapui.toggle,
				vim.tbl_extend("force", keymap_opts, { desc = "Toggle Debug UI" })
			)
			vim.keymap.set("n", "<leader>dx", function()
				dap.terminate()
				dapui.close()
			end, vim.tbl_extend("force", keymap_opts, { desc = "Terminate Debug Session" }))
		end,
	},
}
