return {
	"folke/persistence.nvim",
	lazy = false,
	priority = 100,
	config = function()
		local persistence = require("persistence")
		-- Simple configuration
		local config = {
			auto_load_session = true,
		}
		persistence.setup({
			dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
			save_empty = false,
		})

		-- Close neo-tree before saving session
		vim.api.nvim_create_autocmd("User", {
			pattern = "PersistenceSavePre",
			callback = function()
				pcall(vim.cmd, "Neotree close")
			end,
		})

		-- Auto-load session logic
		local function should_auto_load()
			local cwd = vim.fn.getcwd()
			local home = vim.fn.expand("~")
			-- Don't auto-load in home or root directories
			if cwd == home or cwd == "/" then
				return false
			end
			return vim.fn.argc() == 0 and config.auto_load_session
		end

		-- Load session on startup if appropriate
		if should_auto_load() then
			local session_file = persistence.current()
			if session_file and vim.fn.filereadable(session_file) == 1 then
				local ok = pcall(persistence.load)
				if not ok then
					-- Show dashboard on failure
					if pcall(require, "snacks") then
						require("snacks").dashboard.open()
					end
				else
					-- Reopen neo-tree after session restore
					vim.schedule(function()
						pcall(vim.cmd, "Neotree filesystem show")
					end)
				end
			else
				-- No session, show dashboard
				if pcall(require, "snacks") then
					require("snacks").dashboard.open()
				end
			end
		end

		-- Basic keymaps
		vim.keymap.set("n", "<C-s>", function()
			persistence.save()
			vim.notify("Session saved")
		end, { desc = "Save session", silent = true })

		vim.keymap.set("n", "<leader>pr", function()
			persistence.load()
			-- Reopen neo-tree after manual session restore
			vim.schedule(function()
				pcall(vim.cmd, "Neotree filesystem show")
			end)
		end, { desc = "Restore session" })

		vim.keymap.set("n", "<leader>pl", function()
			persistence.load({ last = true })
			-- Reopen neo-tree after manual session restore
			vim.schedule(function()
				pcall(vim.cmd, "Neotree filesystem show")
			end)
		end, { desc = "Restore last session" })

		vim.keymap.set("n", "<leader>pd", function()
			persistence.stop()
			vim.notify("Session deleted")
		end, { desc = "Delete current session" })

		-- Toggle auto-load
		vim.keymap.set("n", "<leader>pt", function()
			config.auto_load_session = not config.auto_load_session
			vim.notify("Auto-load: " .. (config.auto_load_session and "on" or "off"))
		end, { desc = "Toggle auto-load session" })

		vim.keymap.set("n", "<leader>db", function()
			require("snacks").dashboard.open()
		end, { desc = "Open Dashboard" })
	end,
}
