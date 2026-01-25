local ok, constants = pcall(require, "constants")

-- greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Open file explorer (netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer (netrw)" })

-- Clear search highlighting
vim.keymap.set("n", "<leader>hh", ":noh<CR>", { desc = "Clear search highlighting" })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Paste over selected text without replacing clipboard contents
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection without losing clipboard content" })

-- Replace word under cursor (normal mode)
-- vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor (normal mode)" }
)

-- Replace selection (visual mode)
vim.keymap.set(
	"v",
	"<leader>rw",
	[[y:%s/\V<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
	{ desc = "Replace selected text" }
)

-- Center cursor after moving half a page down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

-- Copy relative file path to clipboard
vim.keymap.set("n", "<leader>cp", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path to clipboard" })

vim.keymap.set("n", "yyc", function()
	local line = vim.api.nvim_get_current_line()
	local row = vim.api.nvim_win_get_cursor(0)[1]

	-- Duplicate line below
	vim.api.nvim_buf_set_lines(0, row, row, false, { line })

	-- Comment out original line
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "// " .. line })

	-- Move cursor to the new (uncommented) line below
	vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end, { desc = "Copy line down and comment out original" })

-- Quit commands
vim.keymap.set("n", "Q", ":qa!<CR>", { desc = "Quit all windows" })
vim.keymap.set("n", "qq", ":qa!<CR>", { desc = "Quit all windows" })
vim.keymap.set("n", "qw", ":q!<CR>", { desc = "Quit current window" })
vim.keymap.set("n", "qb", ":bd<CR>", { desc = "Quit current buffer" })

-- Window resizing
vim.keymap.set({ "n", "v", "i", "t" }, "<M-i>", "<cmd>resize -10<cr>", { desc = "Decrease Window Height" })
vim.keymap.set({ "n", "v", "i", "t" }, "<M-u>", "<cmd>resize +10<cr>", { desc = "Increase Window Height" })
vim.keymap.set({ "n", "v", "i", "t" }, "<M-o>", "<cmd>vertical resize +10<cr>", { desc = "Increase Window Width" })
vim.keymap.set({ "n", "v", "i", "t" }, "<M-y>", "<cmd>vertical resize -10<cr>", { desc = "Decrease Window Width" })

-- Memory stats
vim.keymap.set("n", "<leader>ms", function()
	collectgarbage("collect")
	local lua_kb = collectgarbage("count")
	local lua_mb = math.floor(lua_kb / 1024)

	-- Get total Neovim process memory
	local total_mb = 0
	local handle = io.popen("ps -o rss= -p " .. vim.fn.getpid())
	if handle then
		local result = handle:read("*a")
		handle:close()
		local total_kb = tonumber(result)
		if total_kb then
			total_mb = math.floor(total_kb / 1024)
		end
	end

	local process_names = {
		ts_ls = "typescript-language-server",
		eslint = "vscode-eslint-language-server",
		tailwindcss = "tailwindcss-language-server",
		emmet_ls = "emmet-ls",
		lua_ls = "lua-language-server",
	}

	-- Deduplicate LSP clients by ID
	local lsp_clients = vim.lsp.get_clients()
	local unique_clients = {}
	local seen_ids = {}

	for _, client in ipairs(lsp_clients) do
		if not seen_ids[client.id] then
			seen_ids[client.id] = true
			table.insert(unique_clients, client)
		end
	end

	-- Get LSP server memory by process name
	local client_info = {}
	local lsp_total_mb = 0

	for _, client in ipairs(unique_clients) do
		local mem_mb = 0
		local process_name = process_names[client.name] or client.name
		local cmd = string.format(
			"pgrep -f '%s' | xargs ps -o rss= -p 2>/dev/null | awk '{sum+=$1} END {print sum}'",
			process_name
		)
		local lsp_handle = io.popen(cmd)
		if lsp_handle then
			local lsp_result = lsp_handle:read("*a")
			lsp_handle:close()
			local lsp_kb = tonumber(lsp_result)
			if lsp_kb and lsp_kb > 0 then
				mem_mb = math.floor(lsp_kb / 1024)
				lsp_total_mb = lsp_total_mb + mem_mb
			end
		end
		table.insert(client_info, string.format("%s: %d MB", client.name, mem_mb))
	end

	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local autocmds = vim.api.nvim_get_autocmds({})
	local level = vim.log.levels.INFO
	if total_mb + lsp_total_mb > 500 then
		level = vim.log.levels.ERROR
	elseif total_mb + lsp_total_mb > 300 then
		level = vim.log.levels.WARN
	end

	local report = string.format(
		"Neovim: %d MB\n  ├─ Lua: %d MB (%.1f KB)\n  └─ Native: %d MB\nLSP Servers: %d MB\n  %s\nTotal: %d MB\nBuffers: %d | Autocmds: %d",
		total_mb,
		lua_mb,
		lua_kb,
		total_mb - lua_mb,
		lsp_total_mb,
		table.concat(client_info, "\n  "),
		total_mb + lsp_total_mb,
		#buffers,
		#autocmds
	)
	vim.notify(report, level, { title = "Memory & Resource Stats" })
end, { desc = "Show memory and resource stats" })

-- Send all changed files to dev box (mike)
vim.keymap.set("n", "<leader>sf", function()
	if not ok then
		vim.notify("constants module not available", vim.log.levels.WARN)
		return
	end

	local projects = constants.projects
	local host_list = constants.get_host_list()

	if not projects or #projects == 0 then
		vim.notify("No projects configured", vim.log.levels.ERROR)
		return
	end
	if not host_list or #host_list == 0 then
		vim.notify("No hosts found in data.json", vim.log.levels.ERROR)
		return
	end

	local function sync_files(project, host)
		local cmd = string.format(
			[[cd %s && files=$(git diff --name-only); if [ -z "$files" ]; then echo "NO_CHANGES"; else echo "$files" | while read f; do sendfile "%s/$f" %s "%s/$f"; done; echo "DONE"; fi]],
			project.local_path,
			project.local_path,
			host.name,
			project.remote_path
		)
		vim.fn.jobstart({ "zsh", "-i", "-c", cmd .. " 2>/dev/null" }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				if data then
					local output = table.concat(data, "\n")
					vim.schedule(function()
						if output:match("NO_CHANGES") then
							vim.notify("No changed files to send", vim.log.levels.WARN)
						elseif output:match("DONE") then
							vim.notify("All files sent to " .. host.name .. "!", vim.log.levels.INFO)
						elseif output:match("Sending") then
							vim.notify(output, vim.log.levels.INFO)
						end
					end)
				end
			end,
		})
		vim.notify("Syncing " .. project.name .. " to " .. host.name .. "...", vim.log.levels.INFO)
	end

	-- Step 1: Select project
	vim.ui.select(projects, {
		prompt = "Select project:",
		format_item = function(item)
			return item.name
		end,
	}, function(project)
		if not project then return end
		-- Step 2: Select host
		vim.ui.select(host_list, {
			prompt = "Select host:",
			format_item = function(item)
				return item.name .. " (" .. item.ip .. ")"
			end,
		}, function(host)
			if host then
				sync_files(project, host)
			end
		end)
	end)
end, { desc = "Send changed files to remote host" })
