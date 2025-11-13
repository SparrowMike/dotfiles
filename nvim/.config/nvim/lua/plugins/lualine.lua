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

		-- Cached worktree component to avoid running git commands on every statusline update
		local worktree_cache = {
			cwd = nil,
			result = "",
			last_check = 0,
		}

		local function get_worktree_cached()
			local current_cwd = vim.fn.getcwd()
			local now = vim.loop.hrtime()
			local cache_ttl = 5e9 -- 5 seconds in nanoseconds

			-- Return cached result if still valid
			if worktree_cache.cwd == current_cwd and (now - worktree_cache.last_check) < cache_ttl then
				return worktree_cache.result
			end

			-- Update cache
			worktree_cache.cwd = current_cwd
			worktree_cache.last_check = now

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
							worktree_cache.result = "󰜗 " .. worktree_name
							return worktree_cache.result
						end
					end
				end
			end

			worktree_cache.result = ""
			return ""
		end

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
					-- Worktree component (cached)
					{
						get_worktree_cached,
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
