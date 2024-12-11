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
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Add signs for breakpoints and stopped position
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🔵",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "📝",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "⭐️",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})

            require("dapui").setup()

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
				adapters = { "pwa-chrome", "pwa-node", "node-terminal" },
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
						-- runtimeExecutable = "stable",
						-- sourceMaps = true,
						-- protocol = "inspector",
						-- skipFiles = { "<node_internals>/**", "node_modules/**" },
						-- resolveSourceMapLocations = {
						-- 	"${workspaceFolder}/**",
						-- 	"!**/node_modules/**",
						-- },
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
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.toggle()
			end, vim.tbl_extend("force", keymap_opts, { desc = "Toggle REPL" }))
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

			-- Additional useful debug mappings
			vim.keymap.set(
				"n",
				"<leader>dh",
				dapui.eval,
				vim.tbl_extend("force", keymap_opts, { desc = "Hover Variables" })
			)
			vim.keymap.set(
				"v",
				"<leader>dh",
				dapui.eval,
				vim.tbl_extend("force", keymap_opts, { desc = "Hover Variables" })
			)
			vim.keymap.set(
				"n",
				"<leader>dC",
				dap.run_to_cursor,
				vim.tbl_extend("force", keymap_opts, { desc = "Run to Cursor" })
			)
			vim.keymap.set("n", "<leader>dL", function()
				require("dap").list_breakpoints()
				vim.cmd("copen")
			end, vim.tbl_extend("force", keymap_opts, { desc = "List Breakpoints" }))
			vim.keymap.set("n", "<leader>dX", function()
				require("dap").clear_breakpoints()
				vim.notify("Breakpoints cleared!", vim.log.levels.INFO)
			end, vim.tbl_extend("force", keymap_opts, { desc = "Clear all Breakpoints" }))
		end,
	},
}
