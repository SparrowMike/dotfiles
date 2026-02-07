local M = {}

local tunnel_jobs = {}
local TUNNEL_TIMEOUT_ATTEMPTS = 20 -- 20 * 500ms = 10 second timeout

local function check_port(port)
	local port_num = tonumber(port)
	if not port_num then
		return false
	end
	local result = vim.fn.system("lsof -i :" .. port_num .. " 2>/dev/null")
	return result ~= ""
end

function M.stop_all()
	for key, job_id in pairs(tunnel_jobs) do
		if job_id then
			vim.fn.jobstop(job_id)
			tunnel_jobs[key] = nil
		end
	end
end

function M.get_status()
	local tunnels = {}
	for key, _ in pairs(tunnel_jobs) do
		table.insert(tunnels, key)
	end
	return tunnels
end

function M.ensure(conn, callback)
	local ok, constants = pcall(require, "constants")
	if not ok then
		vim.notify("SSH tunnel requires constants module", vim.log.levels.ERROR)
		if callback then callback(false) end
		return
	end

	if not constants.ssh_user then
		vim.notify("constants.ssh_user is not set", vim.log.levels.ERROR)
		if callback then callback(false) end
		return
	end

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

	-- Handle concurrent requests: if tunnel is being established, wait and retry
	if tunnel_jobs[tunnel_key] ~= nil then
		vim.defer_fn(function()
			M.ensure(conn, callback)
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
		elseif attempts < TUNNEL_TIMEOUT_ATTEMPTS then
			vim.defer_fn(wait_for_port, 500)
		else
			vim.notify("Tunnel timeout for " .. conn.box_ip .. " - check SSH connection", vim.log.levels.ERROR)
			if callback then callback(false) end
		end
	end
	wait_for_port()
end

return M
