return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		-- Add this section to create a Codium status component
		vim.api.nvim_create_user_command("CmpStatus", function()
			local cmp = require("cmp")
			print(vim.inspect(cmp.status))
			-- For more detailed information:
			print(vim.inspect(cmp.core))
		end, {})
		require("lualine").setup({
			options = {
				theme = "auto",
				-- globalstatus = false,
				-- section_separators = { left = "", right = "" },
				-- component_separators = { left = "", right = "" },
				-- theme = bubbles_theme,
				component_separators = "",
				-- section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					-- Worktree component
					{
						function()
							local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
							if handle then
								local git_root = handle:read("*a"):gsub("\n", "")
								handle:close()

								if git_root ~= "" then
									local worktree_name = git_root:match("([^/]+)$")
									local worktree_handle = io.popen("git worktree list --porcelain 2>/dev/null")
									if worktree_handle then
										local worktree_output = worktree_handle:read("*a")
										worktree_handle:close()

										if
											worktree_output:find(git_root)
											and not worktree_output:find("worktree " .. git_root .. "\nbare")
										then
											return "󰜗 " .. worktree_name
										end
									end
								end
							end
							return ""
						end,
						cond = function()
							return vim.fn.isdirectory(".git") == 1 or vim.fn.filereadable(".git") == 1
						end,
						color = { fg = "#98be65" },
					},
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = " ",
						},
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = "●" },
					},
				},
				lualine_x = {
					-- codium_status, -- Add the Codium status component
					-- somestring here add another comment
					{
						function()
							local status = vim.fn["codeium#GetStatusString"]()
							if status == "" then
								return ""
							end
							status = status:gsub("^%s*(.-)%s*$", "%1")
							if status == "ON" then
								return "󰚩 "
							elseif status == "OFF" then
								return "󰚩 OFF"
							elseif status == "*" then
								return "*󰚩*"
							elseif status == "0" then
								return "󰘦 0"
							else
								-- For suggestion counts like "3/8"
								return " " .. status
							end
						end,
					},
					-- "encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location", "os.date('%H:%M')" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					"filename",
				},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
