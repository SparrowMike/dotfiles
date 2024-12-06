return {
	"nvimtools/none-ls.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local eslint = require("none-ls.diagnostics.eslint_d")
		local eslint_actions = require("none-ls.code_actions.eslint_d")

		null_ls.setup({
			sources = {
				-- Prettier config
				null_ls.builtins.formatting.prettierd.with({
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
						"css",
						"scss",
						"less",
						"html",
						"json",
						"jsonc",
						"yaml",
						"markdown",
						"markdown.mdx",
						"handlebars",
					},
				}),
				null_ls.builtins.formatting.stylua,

				-- TODO: only trigger if no linters files are available
				-- require("none-ls.diagnostics.eslint_d"),
				-- require("none-ls.code_actions.eslint_d"),

				-- ESLint config with condition
				eslint.with({
					condition = function(utils)
						return utils.root_has_file({
							".eslintrc.js",
							".eslintrc.cjs",
							".eslintrc.json",
							".eslintrc",
						})
					end,
				}),
				eslint_actions.with({
					condition = function(utils)
						return utils.root_has_file({
							".eslintrc.js",
							".eslintrc.cjs",
							".eslintrc.json",
							".eslintrc",
						})
					end,
				}),
			},
			-- Add debug logging if needed
			debug = false,
		})

		-- Your format keybinding remains the same
		vim.keymap.set("n", "<leader>ll", function()
			vim.lsp.buf.format({
				async = true,
				callback = function()
					-- Check if Tailwind CSS LSP is active
					local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
					local tailwind_active = false
					for _, client in ipairs(clients) do
						if client.name == "tailwindcss" then
							tailwind_active = true
							break
						end
					end

					-- Run TailwindSort only if Tailwind LSP is active
					if tailwind_active then
						vim.cmd("TailwindSort")
					else
						print("[tailwind-tools] Tailwind LSP is not running; skipping TailwindSort.")
					end
				end,
			})
		end, { desc = "Format buffer and optionally Tailwind sort" })

		vim.keymap.set("v", "<leader>ts", function()
			-- Use visual selection with TailwindSortSelection
			vim.cmd("'<,'>TailwindSortSelection")
		end, { desc = "Sort Tailwind classes in the selected text" })
	end,
}
