# Create and setup Python environment for Neovim
-- python3 -m venv ~/.nvim-venv
-- source ~/.nvim-venv/bin/activate
-- pip install pynvim
-- deactivate

return {
    "dcampos/nvim-sftp-sync",
    build = ":UpdateRemotePlugins",
    config = function()
        -- Check for Python environment
        if vim.fn.empty(vim.fn.glob("~/.nvim-venv/bin/python3")) == 1 then
            vim.notify("Python environment not available.", vim.log.levels.ERROR)
            return
        end
        vim.g.python3_host_prog = vim.fn.expand("~/.nvim-venv/bin/python3")

        local project_path = vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(project_path, ":t")

        -- Check required environment variables
        local env_vars = { "SFTP_HOST", "SFTP_PORT", "SFTP_USERNAME", "SFTP_PASSWORD", "SFTP_PATH" }
        for _, var in ipairs(env_vars) do
            if vim.fn.getenv(var) == vim.NIL or vim.fn.getenv(var) == "" then
                vim.notify("Missing environment variable: " .. var, vim.log.levels.ERROR)
                return
            end
        end

        -- Ensure remote path has trailing slash
        local remote_path = vim.fn.getenv("SFTP_PATH")
        if not string.match(remote_path, "/$") then
            remote_path = remote_path .. "/"
        end

        -- Server configuration
        vim.g.sftp_sync_servers = {
            kwweb = {
                name = "My Server",
                host = vim.fn.getenv("SFTP_HOST"),
                port = tonumber(vim.fn.getenv("SFTP_PORT")),
                username = vim.fn.getenv("SFTP_USERNAME"),
                password = vim.fn.getenv("SFTP_PASSWORD"),
                remote_path = remote_path .. project_name,
                local_path = project_path,
                upload_on_save = false,
            },
        }

        -- Create and manage a floating window
        local function create_float(title, content)
            -- Calculate dimensions
            local width = math.floor(vim.o.columns * 0.8)
            local height = #content + 3 -- +3 for title and borders

            -- Create buffer
            local buf = vim.api.nvim_create_buf(false, true)

            -- Set buffer content
            local lines = { title, string.rep("─", width - 2) }
            vim.list_extend(lines, content)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            -- Create window
            local win = vim.api.nvim_open_win(buf, false, {
                relative = "editor",
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                style = "minimal",
                border = "rounded",
            })

            -- Set buffer and window options
            vim.api.nvim_buf_set_option(buf, "modifiable", false)
            vim.api.nvim_win_set_option(win, "winblend", 15)

            return { buf = buf, win = win, lines = #lines }
        end

        -- Update floating window content
        local function update_float(float_data, line_idx, content)
            if not vim.api.nvim_buf_is_valid(float_data.buf) or not vim.api.nvim_win_is_valid(float_data.win) then
                return
            end

            vim.api.nvim_buf_set_option(float_data.buf, "modifiable", true)
            vim.api.nvim_buf_set_lines(float_data.buf, line_idx, line_idx + 1, false, { content })
            vim.api.nvim_buf_set_option(float_data.buf, "modifiable", false)
            vim.cmd("redraw")
        end

        -- Close floating window with a short delay
        local function close_float_with_delay(float_data, delay_ms)
            vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(float_data.buf) then
                    vim.api.nvim_buf_delete(float_data.buf, { force = true })
                end
            end, delay_ms or 2000)
        end

        -- Function to sync git changes
        local function sync_git_changes()
            -- Get modified files
            local modified_cmd = string.format("cd %s && git diff --name-only HEAD", vim.fn.shellescape(project_path))
            local untracked_cmd = string.format("cd %s && git ls-files --others --exclude-standard",
                vim.fn.shellescape(project_path))

            local function get_files_from_command(cmd)
                local handle = io.popen(cmd)
                if not handle then
                    vim.notify("Failed to execute git command", vim.log.levels.ERROR)
                    return {}
                end

                local result = handle:read("*a")
                handle:close()

                local files = {}
                for file in string.gmatch(result, "[^\n]+") do
                    if file ~= "" then
                        table.insert(files, file)
                    end
                end
                return files
            end

            local modified_files = get_files_from_command(modified_cmd)
            local untracked_files = get_files_from_command(untracked_cmd)

            -- Combine files
            local all_files = {}
            for _, file in ipairs(modified_files) do table.insert(all_files, file) end
            for _, file in ipairs(untracked_files) do table.insert(all_files, file) end

            if #all_files == 0 then
                vim.notify("No changes detected to sync", vim.log.levels.INFO)
                return
            end

            -- Remember current buffer
            local current_buf = vim.api.nvim_get_current_buf()
            local current_win = vim.api.nvim_get_current_win()

            -- Create initial content for floating window
            local float_content = {
                string.format("Syncing %d files...", #all_files),
            }

            -- Add placeholder lines for each file
            for i, file in ipairs(all_files) do
                table.insert(float_content, string.format("[%d/%d] %s: Waiting...", i, #all_files, file))
            end

            -- Create summary line
            table.insert(float_content, "")
            table.insert(float_content, "Preparing to sync...")

            -- Create floating window
            local float_data = create_float("SFTP Sync Progress", float_content)

            -- Progress tracking
            local success_count = 0
            local total_files = #all_files

            -- Process files after a short delay to ensure window is visible
            vim.defer_fn(function()
                for i, file in ipairs(all_files) do
                    local full_path = project_path .. "/" .. file

                    if vim.fn.filereadable(full_path) == 1 then
                        -- Update status in floating window
                        update_float(float_data, i + 2, string.format("[%d/%d] %s: Syncing...", i, total_files, file))

                        -- Use existing buffer workflow
                        vim.cmd("edit " .. vim.fn.fnameescape(full_path))

                        -- Try to sync with error handling
                        local ok = pcall(function() vim.cmd("SftpSend") end)

                        if ok then
                            success_count = success_count + 1
                            update_float(float_data, i + 2, string.format("[%d/%d] %s: Success", i, total_files, file))
                        else
                            update_float(float_data, i + 2, string.format("[%d/%d] %s: Failed", i, total_files, file))
                        end

                        -- Small delay to avoid overwhelming the SFTP connection
                        vim.cmd("sleep 100m")
                    else
                        update_float(float_data, i + 2,
                            string.format("[%d/%d] %s: File not readable", i, total_files, file))
                    end
                end

                -- Update summary line
                update_float(float_data, float_data.lines - 1,
                    string.format("Completed: %d/%d files synced successfully", success_count, total_files))

                -- Restore original buffer
                vim.api.nvim_set_current_buf(current_buf)
                vim.api.nvim_set_current_win(current_win)

                -- Close floating window after a delay
                close_float_with_delay(float_data, 3000)

                -- Final status in notification as well
                vim.notify(string.format("Sync completed: %d/%d files synced successfully",
                    success_count, total_files), vim.log.levels.INFO)
            end, 100)
        end

        -- Function to sync current file
        local function sync_current_file()
            local current_file = vim.fn.expand("%:p")
            if current_file == "" then
                vim.notify("No file in current buffer", vim.log.levels.WARN)
                return
            end

            -- Create floating window with status
            local float_data = create_float("SFTP Sync", { "Syncing current file...", current_file })

            -- Try to sync with error handling
            local ok = pcall(function() vim.cmd("SftpSend") end)

            if ok then
                update_float(float_data, 2, "Sync successful: " .. vim.fn.fnamemodify(current_file, ":t"))
                vim.notify("Current file synced", vim.log.levels.INFO)
            else
                update_float(float_data, 2, "Sync failed: " .. vim.fn.fnamemodify(current_file, ":t"))
                vim.notify("Failed to sync current file", vim.log.levels.ERROR)
            end

            -- Close floating window after a delay
            close_float_with_delay(float_data, 2000)
        end

        -- Function to show configuration
        local function show_config()
            local lines = {
                "Host: " .. vim.g.sftp_sync_servers.kwweb.host,
                "Port: " .. vim.g.sftp_sync_servers.kwweb.port,
                "Username: " .. vim.g.sftp_sync_servers.kwweb.username,
                "Password: " .. string.rep("*", 8),
                "",
                "Project Path: " .. project_path,
                "Remote Path: " .. vim.g.sftp_sync_servers.kwweb.remote_path,
                "Upload on Save: " .. tostring(vim.g.sftp_sync_servers.kwweb.upload_on_save)
            }

            local float_data = create_float("SFTP Configuration", lines)
            close_float_with_delay(float_data, 5000)
        end

        -- Keymaps
        vim.keymap.set("n", "<leader>ss", sync_git_changes, { desc = "Sync git changes" })
        vim.keymap.set("n", "<leader>cs", sync_current_file, { desc = "Sync current file" })
        vim.keymap.set("n", "<leader>sc", show_config, { desc = "Show SFTP config" })

        -- Commands
        vim.api.nvim_create_user_command("Sync", sync_git_changes, {})
        vim.api.nvim_create_user_command("SyncCurrent", sync_current_file, {})
        vim.api.nvim_create_user_command("SyncConfig", show_config, {})
    end,
}
