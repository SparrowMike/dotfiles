return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({
			-- Prints debug information
			show_success_message = true,

			-- Prompt for return type and function parameters
			-- Useful for TypeScript
			prompt_func_return_type = {
				javascript = false,
				typescript = true,
			},
			prompt_func_param_type = {
				javascript = false,
				typescript = true,
			},

			-- printf_statements for console.log
			printf_statements = {
				-- For JS/TS, use console.log
				javascript = {
					'console.log("[DEBUG] %s", %s)',
				},
				typescript = {
					'console.log("[DEBUG] %s", %s)',
				},
			},

			-- Print variable debugging
			print_var_statements = {
				javascript = {
					'console.log("[DEBUG VAR] %s:", %s);',
				},
				typescript = {
					'console.log("[DEBUG VAR] %s:", %s);',
				},
			},
		})

		-- Remaps for the refactoring operations
		vim.keymap.set({ "n", "x" }, "<leader>rr", function()
			require("telescope").extensions.refactoring.refactors()
		end, { desc = "Refactor options" })

		-- Extract function supports only visual mode
		vim.keymap.set("x", "<leader>re", function()
			require("refactoring").refactor("Extract Function")
		end, { desc = "Extract function" })

		-- Extract function to file supports only visual mode
		vim.keymap.set("x", "<leader>rf", function()
			require("refactoring").refactor("Extract Function To File")
		end, { desc = "Extract function to file" })

		-- Extract variable supports only visual mode
		vim.keymap.set("x", "<leader>rv", function()
			require("refactoring").refactor("Extract Variable")
		end, { desc = "Extract variable" })

		-- Inline variable supports both normal and visual mode
		vim.keymap.set({ "n", "x" }, "<leader>ri", function()
			require("refactoring").refactor("Inline Variable")
		end, { desc = "Inline variable" })

		-- Inline function supports only normal mode
		vim.keymap.set("n", "<leader>rI", function()
			require("refactoring").refactor("Inline Function")
		end, { desc = "Inline function" })

		-- Extract block supports only normal mode
		vim.keymap.set("n", "<leader>rb", function()
			require("refactoring").refactor("Extract Block")
		end, { desc = "Extract block" })

		-- Extract block to file supports only normal mode
		vim.keymap.set("n", "<leader>rbf", function()
			require("refactoring").refactor("Extract Block To File")
		end, { desc = "Extract block to file" })

		-- Debug operations
		-- Print function call
		vim.keymap.set("n", "<leader>rp", function()
			require("refactoring").debug.printf({ below = false })
		end, { desc = "Debug print function" })

		-- Print variable
		vim.keymap.set({ "x", "n" }, "<leader>rv", function()
			require("refactoring").debug.print_var()
		end, { desc = "Debug print variable" })

		-- Clean up debug prints
		vim.keymap.set("n", "<leader>rc", function()
			require("refactoring").debug.cleanup({})
		end, { desc = "Clean up debug prints" })
	end,
}
