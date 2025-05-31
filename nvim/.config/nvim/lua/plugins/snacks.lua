return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- -@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        -- profiler = { enabled = true, },

        dashboard = {
            sections = {
                { section = "header" },
                { icon = " ",        title = "Keymaps", section = "keys", indent = 2, padding = 1 },

                {
                    icon = " ",
                    title = "Project Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 1,
                    cwd = true,
                    limit = 5,
                },

                { icon = " ",         title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
        },

        explorer = { enabled = true },
        git = { enabled = true },
        gitbrowse = {
            what = "file",
            open = function(url)
                vim.print(url)

                if vim.fn.has("nvim-0.10") == 0 then
                    require("lazy.util").open(url, { system = true })
                    return
                end
                vim.ui.open(url)
            end,
        },
        indent = {
            scope = {
                hl = {
                    "SnacksIndent1",
                    "SnacksIndent2",
                    "SnacksIndent3",
                    "SnacksIndent4",
                    "SnacksIndent5",
                    "SnacksIndent6",
                    "SnacksIndent7",
                    "SnacksIndent8",
                },
            }
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
            top_down = false,
        },
        picker = {
            sources = {
                files = {
                    hidden = true,           -- dotfiles like .env, .gitignore, .config/
                    ignored = false,         -- git-ignored files like node_modules, dist/, build/
                    exclude = {
                        "src/styles/svgs/**",
                        -- "*.svg",
                    }
                },
                explorer = {
                    hidden = true,
                    auto_close = false,
                    win = {
                        list = {
                            wo = {
                                number = true,
                                relativenumber = true,
                                -- signcolumn = "yes"
                            }
                        },
                    },
                    layout = {
                        auto_hide = { "input" },
                        -- preview = true,
                        layout = {
                            position = "right",
                            -- box = 'horizontal',
                            -- position = 'float',
                            -- height = 0.7,
                            -- width = 0.7,
                            -- border = 'rounded',
                            -- {
                            --     box = 'vertical',
                            --     width = 40,
                            --     min_width = 40,
                            --     { win = 'input', height = 1, title = '{title} {live} {flags}', border = 'single' },
                            --     { win = 'list' },
                            -- },
                            -- { win = 'preview', width = 0, border = 'left' },
                            -- { win = 'preview', width = 0, border = 'left', position = 'float' },
                        },
                    },
                },
                projects = {
                    dev = { "~/projects", "~/Documents", "~/Documents/keyboard/" },

                    confirm = function(picker, project_data)
                        -- local path = project_data._path or project_data.file
                        --
                        -- if not path then
                        --     print("Error: No valid path found in project data")
                        --     return
                        -- end
                        --
                        -- vim.cmd('cd ' .. path)
                        --
                        -- local session = require("auto-session")
                        -- if session.session_exists_for_cwd() then
                        --     session.auto_restore_session_at_vim_enter()
                        --     do return picker:close() end
                        -- end
                        --
                        -- local harpoon_ui = require("harpoon.ui")
                        -- if harpoon_ui and harpoon_ui.nav_file(1) then
                        --     harpoon_ui.nav_file(1)
                        --     print("Harpoon triggered")
                        -- else
                        --     vim.cmd('enew')
                        -- end

                        local path = project_data._path or project_data.file
                        if not path then
                            print("Error: No valid path found in project data")
                            return
                        end
                        vim.cmd('cd ' .. path)
                        local ok, harpoon_ui = pcall(require, "harpoon.ui")
                        if ok and harpoon_ui and harpoon_ui.nav_file then
                            pcall(harpoon_ui.nav_file, 1)
                            print("Harpoon triggered")
                        else
                            Snacks.dashboard.open()
                        end
                        picker:close()
                    end,

                    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile", "webpack.config.js" },
                }
            },
            formatters = {
                file = {
                    truncate = 1000,
                },
            },
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = {
            folds = {
                git_hl = true, -- use Git Signs hl for fold icons
            },
        },
        words = { enabled = true },
        win = { enabled = true },
        styles = {
            notification = {
                -- wo = { wrap = true } -- Wrap notifications
            }
        }
    },
    keys = {
        -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>/",       function() Snacks.picker.grep({ regex = false }) end,                   desc = "Grep" },
        { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
        { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },

        -- find
        { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
        { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
        { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },

        -- git
        { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
        { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
        { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
        { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
        { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
        { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
        { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },

        -- Grep
        { "<leader>sl",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
        { "<leader>sg",      function() Snacks.picker.grep({ regex = false }) end,                   desc = "Grep" },
        { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },

        -- search
        { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
        { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
        { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
        { "<leader>sl",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
        { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
        { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
        { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
        { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
        { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
        { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
        { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
        -- { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
        { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
        { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
        { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
        { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
        { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
        { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
        { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },

        -- LSP
        -- { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
        -- { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
        -- { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
        -- { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
        -- { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
        -- { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        -- { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },

        -- Other
        { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
        { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
        { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
        { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
        { "<leader>nh",      function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
        { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
        { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
        { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },

        { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
        { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
        { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
        { "<c-.>",           function() Snacks.terminal.open() end,                                  desc = "Toggle Terminal" },
        { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
        -- { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
        -- { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
        {
            "<leader>N",
            desc = "Neovim News",
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = "yes",
                        statuscolumn = " ",
                        conceallevel = 3,
                    },
                })
            end,
        }
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                    "<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })

        vim.ui.select = require("snacks.picker").select
    end,
}
