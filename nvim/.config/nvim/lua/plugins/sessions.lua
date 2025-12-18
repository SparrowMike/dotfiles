return {
    {
        "folke/persistence.nvim",
        lazy = false,
        config = function()
            local persistence = require("persistence")

            local auto_load_enabled = true

            persistence.setup({
                dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
                -- Remove "folds" to prevent issues with unloaded buffers
                options = { "buffers", "curdir", "tabpages", "winsize", "skiprtp" },
                save_empty = false,
            })

            -- Clean session state before saving (prevents session bloat)
            vim.api.nvim_create_autocmd("User", {
                pattern = "PersistenceSavePre",
                callback = function()
                    -- Close special buffers that shouldn't be persisted
                    pcall(vim.cmd, "Neotree close")
                    pcall(vim.cmd, "DiffviewClose")

                    -- Close all floating windows
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local config = vim.api.nvim_win_get_config(win)
                        if config.relative ~= "" then
                            pcall(vim.api.nvim_win_close, win, true)
                        end
                    end

                    -- Remove invalid/deleted file buffers (do this BEFORE persistence saves)
                    local bufs_to_delete = {}
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_valid(buf) then
                            local name = vim.api.nvim_buf_get_name(buf)
                            local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
                            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

                            -- Skip special buffer types
                            if buftype ~= "" then
                                goto continue
                            end

                            -- Skip dashboard/startup buffers
                            if filetype == "dashboard" or filetype == "alpha" or filetype == "starter" then
                                table.insert(bufs_to_delete, buf)
                                goto continue
                            end

                            -- Delete buffers for files that no longer exist
                            if name ~= "" and vim.fn.filereadable(name) == 0 and not name:match("^%w+://") then
                                table.insert(bufs_to_delete, buf)
                            end
                        end
                        ::continue::
                    end

                    -- Delete collected buffers after iteration completes
                    for _, buf in ipairs(bufs_to_delete) do
                        pcall(vim.api.nvim_buf_delete, buf, { force = true })
                    end
                end,
            })

            -- Auto-load session on startup (only when appropriate)
            -- NOTE: Prefer using dashboard (<leader>db) to load sessions interactively
            vim.api.nvim_create_autocmd("VimEnter", {
                nested = true, -- Allow nested autocmds to fire during session load
                callback = function()
                    if not auto_load_enabled then
                        return
                    end

                    -- Skip if nvim was opened with arguments (files/dirs)
                    if vim.fn.argc() > 0 then
                        return
                    end

                    local cwd = vim.fn.getcwd()
                    local home = vim.fn.expand("~")

                    -- Don't auto-load in home or root directories
                    if cwd == home or cwd == "/" then
                        return
                    end

                    -- Check if session exists before loading
                    local session_file = persistence.current()
                    if session_file and vim.fn.filereadable(session_file) == 1 then
                        local ok, err = pcall(persistence.load)
                        if not ok then
                            vim.notify("Failed to load session: " .. tostring(err), vim.log.levels.WARN)
                        end
                    end
                end,
            })

            -- User commands for session management
            vim.api.nvim_create_user_command("PersistenceSave", function()
                persistence.save()
                vim.notify("Session saved", vim.log.levels.INFO)
            end, { desc = "Save current session" })

            vim.api.nvim_create_user_command("PersistenceLoad", function()
                persistence.load()
            end, { desc = "Load session for current directory" })

            vim.api.nvim_create_user_command("PersistenceSelect", function()
                persistence.select()
            end, { desc = "Select a session to load" })

            -- Diagnostic command: View session health and stats
            vim.api.nvim_create_user_command("SessionInfo", function()
                local session_file = persistence.current()
                if not session_file or vim.fn.filereadable(session_file) == 0 then
                    vim.notify("No session file found for current directory", vim.log.levels.WARN)
                    return
                end

                local lines = vim.fn.readfile(session_file)
                local buffers = {}
                local buf_count = 0

                for _, line in ipairs(lines) do
                    if line:match("^badd") then
                        buf_count = buf_count + 1
                        local path = line:match("badd %+%d+ (.+)") or line:match("badd (.+)")
                        if path then
                            local expanded = vim.fn.expand(path)
                            -- Check if it's a valid file (not directory, not non-existent)
                            local exists = vim.fn.filereadable(expanded) == 1
                            table.insert(buffers, { path = path, exists = exists })
                        end
                    end
                end

                local invalid = vim.tbl_filter(function(b) return not b.exists end, buffers)
                local file_size = vim.fn.getfsize(session_file)

                print(string.format("Session: %d lines, %d buffers, %.1f KB", #lines, buf_count, file_size / 1024))

                if #invalid > 0 then
                    print(string.format("\nWARNING: %d invalid/deleted files:", #invalid))
                    for i, b in ipairs(invalid) do
                        if i <= 10 then -- Limit output
                            print("  - " .. b.path)
                        end
                    end
                    if #invalid > 10 then
                        print(string.format("  ... and %d more", #invalid - 10))
                    end
                    print("\nRun :PersistenceSave to clean these up automatically")
                else
                    print("\nSession is clean! ✓")
                end
            end, { desc = "Show session file statistics" })
        end,
    },
}
