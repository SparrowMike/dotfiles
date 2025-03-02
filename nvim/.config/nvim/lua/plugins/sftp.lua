# Create and setup Python environment for Neovim
-- python3 -m venv ~/.nvim-venv
-- source ~/.nvim-venv/bin/activate
-- pip install pynvim
-- deactivate

return {
    "dcampos/nvim-sftp-sync",
    build = ":UpdateRemotePlugins",
    config = function()
        if vim.fn.empty(vim.fn.glob("~/.nvim-venv/bin/python3")) == 1 then
            vim.notify("Python environment not available.")
            return
        end

        vim.g.python3_host_prog = vim.fn.expand("~/.nvim-venv/bin/python3")

        local project_path = vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(project_path, ":t")

        -- Server configuration
        vim.g.sftp_sync_servers = {
            kwweb = {
                name = "My Server",
                host = vim.fn.getenv("SFTP_HOST"),
                port = tonumber(vim.fn.getenv("SFTP_PORT")),
                username = vim.fn.getenv("SFTP_USERNAME"),
                password = vim.fn.getenv("SFTP_PASSWORD"),
                -- remote_path = vim.fn.getenv("SFTP_PATH") .. "/" .. project_name,
                remote_path = vim.fn.getenv("SFTP_PATH") .. project_name,
                local_path = project_path,
                upload_on_save = false,
            },
        }

        -- Function to sync git changes
        local function sync_git_changes()
            -- Get modified files
            local cmd = string.format("cd %s && git diff --name-only HEAD", project_path)
            local handle = io.popen(cmd)
            if not handle then
                vim.notify("Failed to get git changes", vim.log.levels.ERROR)
                return
            end

            local result = handle:read("*a")
            handle:close()

            -- Process each file
            for file in result:gmatch("[^\n]+") do
                local full_path = project_path .. "/" .. file
                if vim.fn.filereadable(full_path) == 1 then
                    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                    vim.cmd("SftpSend")
                    vim.cmd("sleep 100m")
                    vim.notify("File synced: " .. file, vim.log.levels.INFO)
                end
            end

            vim.notify("Sync completed", vim.log.levels.INFO)
        end

        -- Function to sync current file
        local function sync_current_file()
            if vim.fn.expand("%:p") == "" then
                vim.notify("No file in current buffer", vim.log.levels.WARN)
                return
            end

            vim.cmd("SftpSend")
            vim.notify("Current file synced", vim.log.levels.INFO)
        end

        -- Function to log messages
        local function log_message()
            local remote_path = vim.fn.getenv("SFTP_PATH") .. project_name
            vim.notify("Project Path: " .. project_path .. "\nRemote Path: " .. remote_path, vim.log.levels.INFO)
        end

        -- Keymaps
        -- vim.keymap.set("n", "<leader>sl", log_message, { desc = "Sync git changes" })
        vim.keymap.set("n", "<leader>ss", sync_git_changes, { desc = "Sync git changes" })
        vim.keymap.set("n", "<leader>cs", sync_current_file, { desc = "Sync current file" })

        -- Commands
        vim.api.nvim_create_user_command("Sync", sync_git_changes, {})
        vim.api.nvim_create_user_command("SyncCurrent", sync_current_file, {})
    end,
}
