return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
		vim.g.db_ui_winwidth = 40
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_use_nvim_notify = 1

		local function url_encode(str)
			return str:gsub("([^%w%-_.~])", function(c)
				return string.format("%%%02X", string.byte(c))
			end)
		end

		local ok, constants = pcall(require, "constants")
		if ok and constants.connections then
			local dbs = {}
			for _, conn in ipairs(constants.connections) do
				local url = conn.url
				if url then
					local user, pass, host, port, db_part = url:match("([^:]+):([^@]+)@tcp%(([^:]+):(%d+)%)/?(.*)")
					if user and host then
						local db = db_part and db_part:match("([^?]+)") or ""
						local dadbod_url = string.format(
							"%s://%s:%s@%s:%s/%s?skip-ssl",
							conn.type or "mysql", url_encode(user), url_encode(pass), host, port, db
						)
						table.insert(dbs, { name = conn.name or conn.key, url = dadbod_url })
					elseif url:match("^%w+://") then
						table.insert(dbs, { name = conn.name or conn.key, url = url })
					end
				end
			end
			vim.g.dbs = dbs
			vim.g.db_connections = constants.connections
		end
	end,
	config = function()
		local tunnel = require("utils.ssh-tunnel")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				require("cmp").setup.buffer({
					sources = {
						{ name = "vim-dadbod-completion" },
						{ name = "luasnip" },
						{ name = "buffer" },
					},
				})
			end,
		})

		-- Find connection by matching database name from DBUI line
		local function find_conn_for_db(db_name)
			local connections = vim.g.db_connections or {}
			for _, conn in ipairs(connections) do
				local name = conn.name or conn.key
				if db_name:find(name, 1, true) or name:find(db_name, 1, true) then
					return conn
				end
			end
			return nil
		end

		-- Expand database with auto-tunnel
		local function dbui_expand_with_tunnel()
			local line = vim.fn.getline(".")
			local db_name = line:match("^%s*[▸▾]?%s*(.-)%s*$") or line:match("^%s*(.-)%s*$")

			if db_name and db_name ~= "" then
				local conn = find_conn_for_db(db_name)
				if conn and conn.box_ip and conn.local_port then
					tunnel.ensure(conn, function(success)
						if success then
							-- Small delay to let SSH tunnel fully stabilize
							vim.defer_fn(function()
								vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(DBUI_SelectLine)", true, true, true), "n")
							end, 200)
						else
							vim.schedule(function()
								vim.notify("Tunnel failed - database expansion aborted", vim.log.levels.WARN)
							end)
						end
					end)
					return
				end
			end
			-- No tunnel needed, just expand
			vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(DBUI_SelectLine)", true, true, true), "n")
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dbui",
			callback = function()
				vim.opt_local.relativenumber = true
				vim.opt_local.number = true

				-- Remap expand keys to auto-establish tunnel
				vim.keymap.set("n", "o", dbui_expand_with_tunnel, { buffer = true, silent = true, desc = "Expand with tunnel" })
				vim.keymap.set("n", "<CR>", dbui_expand_with_tunnel, { buffer = true, silent = true, desc = "Expand with tunnel" })
			end,
		})

		local function is_db_tab(tab)
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.bo[buf].filetype
				if ft == "dbui" or ft == "dbout" then
					return true
				end
			end
			return false
		end

		local function open_dbui_in_tab()
			-- If currently in a DB tab, close it
			local current_tab = vim.api.nvim_get_current_tabpage()
			if is_db_tab(current_tab) then
				-- Close the DB tab if there are other tabs
				if #vim.api.nvim_list_tabpages() > 1 then
					vim.cmd("tabclose")
				else
					vim.cmd("DBUI") -- Toggle DBUI panel if it's the only tab
				end
				return
			end

			-- Look for existing DB tab
			for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
				if is_db_tab(tab) then
					vim.api.nvim_set_current_tabpage(tab)
					vim.cmd("DBUI")
					return
				end
			end

			-- No DB tab found, create new one
			vim.cmd("tabnew")
			vim.cmd("DBUI")
		end

		local function connect_to_db(conn)
			tunnel.ensure(conn, function(success)
				if success then
					open_dbui_in_tab()
				end
			end)
		end

		vim.api.nvim_create_user_command("DBConnect", function(opts)
			local connections = vim.g.db_connections or {}
			local conn_key = opts.args

			if conn_key == "" then
				local items = {}
				local conn_map = {}
				for _, conn in ipairs(connections) do
					local display = conn.name or conn.key
					if conn.box_ip then
						display = display .. " (" .. conn.box_ip .. ")"
					end
					table.insert(items, display)
					conn_map[display] = conn
				end

				vim.ui.select(items, { prompt = "Select DB connection:" }, function(choice)
					if choice and conn_map[choice] then
						connect_to_db(conn_map[choice])
					end
				end)
				return
			end

			for _, conn in ipairs(connections) do
				if conn.key == conn_key then
					connect_to_db(conn)
					return
				end
			end
			vim.notify("Connection not found: " .. conn_key, vim.log.levels.ERROR)
		end, {
			nargs = "?",
			complete = function()
				local keys = {}
				for _, conn in ipairs(vim.g.db_connections or {}) do
					table.insert(keys, conn.key)
				end
				return keys
			end,
			desc = "Connect to DB with auto-tunnel",
		})

		vim.api.nvim_create_user_command("DBDisconnect", function()
			tunnel.stop_all()
			vim.notify("All tunnels stopped", vim.log.levels.INFO)
		end, { desc = "Stop all DB tunnels" })

		vim.api.nvim_create_user_command("DBStatus", function()
			local tunnels = tunnel.get_status()
			if #tunnels == 0 then
				vim.notify("No active tunnels", vim.log.levels.INFO)
			else
				vim.notify("Active tunnels (" .. #tunnels .. "): " .. table.concat(tunnels, ", "), vim.log.levels.INFO)
			end
		end, { desc = "Show active DB tunnels" })

		vim.api.nvim_create_user_command("DBToggle", function()
			local connections = vim.g.db_connections or {}
			if #connections == 1 then
				connect_to_db(connections[1])
			else
				open_dbui_in_tab()
			end
		end, { desc = "Toggle Dadbod UI" })

		vim.api.nvim_create_user_command("DBClean", function()
			local closed = 0
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("%.dbout$") then
					vim.api.nvim_buf_delete(buf, { force = true })
					closed = closed + 1
				end
			end
			vim.notify("Closed " .. closed .. " dbout buffer(s)", vim.log.levels.INFO)
		end, { desc = "Close all DB result buffers" })

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = tunnel.stop_all,
		})
	end,
	keys = {
		{ "<leader>dc", "<cmd>DBConnect<cr>", desc = "Dadbod Connect (picker)" },
		{ "<leader>dd", "<cmd>DBToggle<cr>", desc = "Toggle Dadbod UI" },
		{ "<leader>dx", "<cmd>DBClean<cr>", desc = "Clean DB result buffers" },
		{ "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
		{ "<leader>dq", "<cmd>DBDisconnect<cr>", desc = "Dadbod Disconnect" },
		{ "<leader>di", "<cmd>DBStatus<cr>", desc = "Dadbod Tunnel Status" },
		{ "<leader>de", "<Plug>(DBUI_ExecuteQuery)", ft = { "sql", "mysql", "plsql" }, desc = "Execute Query" },
		{ "<leader>ds", "<Plug>(DBUI_SaveQuery)", ft = { "sql", "mysql", "plsql" }, desc = "Save Query" },
		{ "<leader>de", "<Plug>(DBUI_ExecuteQuery)", mode = "v", ft = { "sql", "mysql", "plsql" }, desc = "Execute Selection" },
	},
}
