vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamed"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"
-- vim.opt.signcolumn = "yes"

vim.opt.foldmethod = "expr"                     -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
-- vim.opt.foldenable = false

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.g.mapleader = " "

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
  "declaration",
  "expression",
  "pattern",
  "primary_expression",
  "statement",
  "switch_body",
}

vim.opt.termguicolors = true

-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
