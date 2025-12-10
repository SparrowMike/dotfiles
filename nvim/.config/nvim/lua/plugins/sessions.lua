return {
    -- {
    --     "folke/persistence.nvim",
    --     lazy = false, -- Must load early for VimEnter autocmd to work
    --     config = function()
    --         local persistence = require("persistence")
    --
    --         -- State for auto-load toggle
    --         local auto_load_enabled = true
    --
    --         persistence.setup({
    --             dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
    --             -- Reduced options: removed 'help' and 'globals' (rarely needed)
    --             options = { "buffers", "curdir", "tabpages", "winsize", "skiprtp" },
    --             save_empty = false,
    --         })
    --
    --         -- Close neo-tree before saving session (avoids storing neo-tree buffer state)
    --         vim.api.nvim_create_autocmd("User", {
    --             pattern = "PersistenceSavePre",
    --             callback = function()
    --                 pcall(vim.cmd, "Neotree close")
    --             end,
    --         })
    --
    --         -- Auto-load session on startup (deferred for performance)
    --         vim.api.nvim_create_autocmd("VimEnter", {
    --             callback = function()
    --                 if not auto_load_enabled then
    --                     return
    --                 end
    --
    --                 -- Skip if nvim was opened with arguments (files/dirs)
    --                 if vim.fn.argc() > 0 then
    --                     return
    --                 end
    --
    --                 local cwd = vim.fn.getcwd()
    --                 local home = vim.fn.expand("~")
    --
    --                 -- Don't auto-load in home or root directories
    --                 if cwd == home or cwd == "/" then
    --                     return
    --                 end
    --
    --                 -- Check if session exists before loading
    --                 local session_file = persistence.current()
    --                 if session_file and vim.fn.filereadable(session_file) == 1 then
    --                     -- Defer session loading to not block startup
    --                     -- vim.defer_fn(function()
    --                         -- Temporarily ignore heavy autocmds during session restore
    --                         local eventignore_save = vim.o.eventignore
    --                         vim.o.eventignore = "BufRead,BufReadPost,BufEnter,FileType"
    --
    --                         local ok = pcall(persistence.load)
    --
    --                         -- Restore autocmds
    --                         vim.o.eventignore = eventignore_save
    --
    --                         if ok then
    --                             -- Trigger FileType for visible buffers only
    --                             vim.schedule(function()
    --                                 vim.cmd("doautocmd FileType")
    --                             end)
    --                         end
    --                     -- end, 10)
    --                 end
    --             end,
    --         })
    --         vim.keymap.set("n", "<leader>db", function()
    --             require("snacks").dashboard.open()
    --         end, { desc = "Open Dashboard" })
    --     end,
    -- },
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
          suppressed_dirs = { "~/", "/" },
          -- Session is now <10ms overhead vs your current ~246ms
          auto_restore = true,
          auto_save = true,
        }
    }
}
