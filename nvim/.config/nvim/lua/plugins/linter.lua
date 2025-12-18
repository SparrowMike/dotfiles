return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					-- JS/TS: ESLint with stylistic rules
					javascript = { "eslint_d" },
					javascriptreact = { "eslint_d" },
					typescript = { "eslint_d" },
					typescriptreact = { "eslint_d" },
					vue = { "eslint_d" },
					-- Style files: Keep Prettier for non-JS files
					css = { "prettierd" },
					scss = { "prettierd" },
					less = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					jsonc = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					-- Python: ruff for formatting and import sorting
					python = { "ruff_format", "ruff_organize_imports" },
					-- Other
					lua = { "stylua" },
				},

				-- Better performance: only run formatters when config exists
				formatters = {
					prettierd = {
						condition = function(self, ctx)
							return vim.fs.find({
								".prettierrc",
								".prettierrc.json",
								".prettierrc.js",
								".prettierrc.yml",
								".prettierrc.yaml",
								"prettier.config.js",
								"package.json", -- Often has prettier config
							}, { path = ctx.filename, upward = true })[1]
						end,
					},
					eslint_d = {
						condition = function(self, ctx)
							return vim.fs.find({
								".eslintrc",
								".eslintrc.js",
								".eslintrc.json",
								".eslintrc.yml",
								".eslintrc.yaml",
								"eslint.config.js",
								"eslint.config.mjs",
							}, { path = ctx.filename, upward = true })[1]
						end,
						-- Ensure we're using --fix
						args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
					},
					-- Ruff: minimal config (auto-detects project settings)
					ruff_format = {},
					ruff_organize_imports = {},
				},

				-- Show errors when formatting fails
				notify_on_error = true,
			})

			-- Helper for Tailwind sorting with better error handling (original approach)
			local function sort_tailwind()
				local ok, result = pcall(function()
					-- Try tailwind-tools first (if you have it)
					local has_tw_tools, tw_tools = pcall(require, "tailwind-tools")
					if has_tw_tools and tw_tools.sort then
						tw_tools.sort()
					else
						-- Fallback to built-in command
						vim.cmd("TailwindSort")
					end
				end)
				if not ok then
					vim.notify("Tailwind sort failed: " .. tostring(result), vim.log.levels.WARN)
				end			end

			vim.keymap.set("n", "<leader>lx", function()
				vim.lsp.buf.code_action({
					filter = function(action)
						-- Fix all available from any LSP
						return action.kind and action.kind:match("^source%.fixAll")
					end,
					apply = true,
				})
			end, { desc = "Fix all (code actions)" })

			vim.keymap.set("n", "<leader>ll", function()
				require("conform").format({
					async = true,
					timeout_ms = 3000,
				}, function(err)
					if not err then
						vim.defer_fn(sort_tailwind, 100)
					else
						vim.notify("Format failed: " .. err, vim.log.levels.ERROR)
					end
				end)
			end, { desc = "Format (with fixes) + sort Tailwind" })

			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				require("conform").format({
					async = true,
					timeout_ms = 3000,
				})
			end, { desc = "Format code" })

			vim.keymap.set("n", "<leader>st", sort_tailwind, { desc = "Sort Tailwind classes" })

			-- Visual mode Tailwind sort (original approach)
			vim.keymap.set("v", "<leader>st", function()
				local ok, result = pcall(function()
					local has_tw_tools, tw_tools = pcall(require, "tailwind-tools")
					if has_tw_tools and tw_tools.sort then
						-- Use visual selection
						tw_tools.sort({
							start_line = vim.fn.line("'<"),
							end_line = vim.fn.line("'>"),
						})
					else
						-- Fallback command
						vim.cmd("'<,'>TailwindSortSelection")
					end
				end)
				if not ok then
					vim.notify("Tailwind sort selection failed: " .. tostring(result), vim.log.levels.WARN)
				end
			end, { desc = "Sort Tailwind classes in selection" })

			-- Auto-stop tailwind LSP clients on exit to prevent zombies
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					-- Only stop LSP clients attached to this instance (non-blocking)
					for _, client in ipairs(vim.lsp.get_clients()) do
						if client.name == "tailwindcss" then
							client.stop()
						end
					end
				end,
			})

			-- Emergency command to stop runaway LSP clients
			vim.api.nvim_create_user_command("KillTailwindLSP", function()
				local count = 0
				for _, client in ipairs(vim.lsp.get_clients()) do
					if client.name == "tailwindcss" then
						client.stop()
						count = count + 1
					end
				end
				vim.notify("Stopped " .. count .. " Tailwind LSP client(s)", vim.log.levels.INFO)
			end, { desc = "Stop all Tailwind LSP clients" })
		end,
	},

	-- ESLint diagnostics AND code actions (same as before)
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local eslint_diagnostics = require("none-ls.diagnostics.eslint_d")
			local eslint_code_actions = require("none-ls.code_actions.eslint_d")

			null_ls.setup({
				debounce = 250, -- Slightly faster feedback
				sources = {
					-- ESLint diagnostics (shows the problems)
					eslint_diagnostics.with({
						-- Only attach if ESLint config exists
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc",
								".eslintrc.js",
								".eslintrc.json",
								".eslintrc.yml",
								".eslintrc.yaml",
								"eslint.config.js",
							})
						end,
					}),
					-- ESLint code actions (provides the fixes)
					eslint_code_actions.with({
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc",
								".eslintrc.js",
								".eslintrc.json",
								".eslintrc.yml",
								".eslintrc.yaml",
								"eslint.config.js",
							})
						end,
					}),
					-- Note: Python linting is now handled by ruff LSP (see lsp.lua)
				},
			})
		end,
	},

	-- Enhanced tailwind-tools.nvim (for sorting without LSP)
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		event = "BufReadPre",
		ft = { "html", "css", "scss", "less", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		build = ":UpdateRemotePlugins",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("tailwind-tools").setup({
				-- DO NOT use the heavy LSP server
				server = {
					override = false, -- Critical: don't start the problematic LSP
				},
				-- Lightweight color previews
				document_color = {
					enabled = true,
					kind = "foreground", -- Less intensive
					debounce = 500,
				},
				conceal = {
					enabled = false, -- Keep disabled for performance
				},
			})
		end,
	},
}
