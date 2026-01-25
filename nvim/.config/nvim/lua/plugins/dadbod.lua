local tunnel_jobs = {}

-- Expose for lualine/statusline integration
_G.dadbod_tunnel_status = function()
	local count = vim.tbl_count(tunnel_jobs)
	return count > 0 and ("DB:" .. count) or ""
end

local function check_port(port)
	local result = vim.fn.system("lsof -i :" .. port .. " 2>/dev/null")
	return result ~= ""
end

local function stop_all_tunnels()
	for key, job_id in pairs(tunnel_jobs) do
		if job_id then
			vim.fn.jobstop(job_id)
			tunnel_jobs[key] = nil
		end
	end
end

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
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_winwidth = 40

		local ok, constants = pcall(require, "constants")
		if ok and constants.connections then
			local dbs = {}
			for _, conn in ipairs(constants.connections) do
				local url = conn.url
				if url then
					local user, pass, host, port, db_part = url:match("([^:]+):([^@]+)@tcp%(([^:]+):(%d+)%)/?(.*)")
					if user and host then
						-- Strip query params from db name
						local db = db_part and db_part:match("([^?]+)") or ""
						-- Use skip-ssl for homebrew mysql client
						local dadbod_url = string.format(
							"%s://%s:%s@%s:%s/%s?skip-ssl",
							conn.type or "mysql", user, pass, host, port, db
						)
						table.insert(dbs, { name = conn.name or conn.key, url = dadbod_url })
					end
				end
			end
			vim.g.dbs = dbs
			vim.g.db_connections = constants.connections
		end
	end,
	config = function()
		local ok, constants = pcall(require, "constants")
		if not ok then return end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				require("cmp").setup.buffer({
					sources = {
						{ name = "vim-dadbod-completion" },
						{ name = "buffer" },
					},
				})
			end,
		})

		local function ensure_tunnel(conn, callback)
			if not conn.box_ip or not conn.local_port then
				if callback then callback(true) end
				return
			end

			local local_port = conn.local_port
			local tunnel_key = conn.box_ip .. ":" .. local_port

			if check_port(local_port) then
				vim.notify("Tunnel to " .. conn.box_ip .. " already active", vim.log.levels.INFO)
				if callback then callback(true) end
				return
			end

			if tunnel_jobs[tunnel_key] ~= nil then
				vim.defer_fn(function()
					ensure_tunnel(conn, callback)
				end, 500)
				return
			end

			vim.notify("Establishing SSH tunnel to " .. conn.box_ip .. "...", vim.log.levels.INFO)
			local job_id = vim.fn.jobstart({
				"ssh",
				"-L",
				local_port .. ":127.0.0.1:3306",
				"-o",
				"ServerAliveInterval=60",
				"-o",
				"ExitOnForwardFailure=yes",
				"-N",
				constants.ssh_user .. "@" .. conn.box_ip,
			}, {
				detach = true,
				on_stderr = function(_, data)
					if data and #data > 0 then
						local err = table.concat(data, "\n")
						if err:match("%S") then
							vim.notify("SSH Error (" .. conn.box_ip .. "): " .. err, vim.log.levels.ERROR)
						end
					end
				end,
				on_exit = function(_, code)
					tunnel_jobs[tunnel_key] = nil
					if code ~= 0 then
						vim.notify("SSH tunnel to " .. conn.box_ip .. " failed (exit code: " .. code .. ")", vim.log.levels.ERROR)
					end
				end,
			})

			if job_id <= 0 then
				vim.notify("Failed to start SSH tunnel job", vim.log.levels.ERROR)
				if callback then callback(false) end
				return
			end
			tunnel_jobs[tunnel_key] = job_id

			local attempts = 0
			local function wait_for_port()
				attempts = attempts + 1
				-- Check if job already failed
				if tunnel_jobs[tunnel_key] == nil then
					if callback then callback(false) end
					return
				end
				if check_port(local_port) then
					vim.notify("SSH tunnel to " .. conn.box_ip .. " ready", vim.log.levels.INFO)
					if callback then callback(true) end
				elseif attempts < 20 then
					vim.defer_fn(wait_for_port, 500)
				else
					vim.notify("Tunnel timeout for " .. conn.box_ip .. " - check SSH connection", vim.log.levels.ERROR)
					if callback then callback(false) end
				end
			end
			wait_for_port()
		end

		local function connect_to_db(conn)
			ensure_tunnel(conn, function(success)
				if success then
					vim.cmd("DBUIToggle")
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
			stop_all_tunnels()
			vim.notify("All tunnels stopped", vim.log.levels.INFO)
		end, { desc = "Stop all DB tunnels" })

		vim.api.nvim_create_user_command("DBStatus", function()
			local count = vim.tbl_count(tunnel_jobs)
			if count == 0 then
				vim.notify("No active tunnels", vim.log.levels.INFO)
			else
				local tunnels = {}
				for key, _ in pairs(tunnel_jobs) do
					table.insert(tunnels, key)
				end
				vim.notify("Active tunnels (" .. count .. "): " .. table.concat(tunnels, ", "), vim.log.levels.INFO)
			end
		end, { desc = "Show active DB tunnels" })

		vim.api.nvim_create_user_command("DBToggle", function()
			local connections = vim.g.db_connections or {}
			if #connections == 1 then
				connect_to_db(connections[1])
			else
				vim.cmd("DBUIToggle")
			end
		end, { desc = "Toggle Dadbod UI" })

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = stop_all_tunnels,
		})
	end,
	keys = {
		{ "<leader>dc", "<cmd>DBConnect<cr>", desc = "Dadbod Connect (picker)" },
		{ "<leader>dd", "<cmd>DBToggle<cr>", desc = "Toggle Dadbod UI" },
		{ "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
		{ "<leader>dq", "<cmd>DBDisconnect<cr>", desc = "Dadbod Disconnect" },
		{ "<leader>di", "<cmd>DBStatus<cr>", desc = "Dadbod Tunnel Status" },
		{ "<leader>de", "<Plug>(DBUI_ExecuteQuery)", ft = { "sql", "mysql", "plsql" }, desc = "Execute Query" },
		{ "<leader>ds", "<Plug>(DBUI_SaveQuery)", ft = { "sql", "mysql", "plsql" }, desc = "Save Query" },
		{ "<leader>de", "<Plug>(DBUI_ExecuteQuery)", mode = "v", ft = { "sql", "mysql", "plsql" }, desc = "Execute Selection" },
	},
}
