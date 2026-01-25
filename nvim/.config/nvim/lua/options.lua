vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- UI Settings
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- File-specific indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.shiftwidth = 4
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 4
		vim.bo.expandtab = true
	end,
})

-- Text display
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.list = true
-- vim.opt.listchars = {
-- 	tab = "→ ",
-- 	trail = "·",
-- 	extends = "›",
-- 	precedes = "‹",
-- }
vim.opt.spelllang = "en_us"

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true

-- Auto-reload files changed externally (e.g., by Claude)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Folding (modern treesitter)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Session options
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Additional settings
vim.opt.isfname:append("@-@")
vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"

vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Better diff mode
vim.opt.diffopt:append({ "linematch:60", "algorithm:histogram" })

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
