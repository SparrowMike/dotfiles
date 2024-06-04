return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim", -- eslint_d
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "json",
            "jsonc",
            "yaml",
            "markdown",
            "markdown.mdx",
            "handlebars",
          },
        }),
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.diagnostics.stylelint,
        require("none-ls.diagnostics.eslint_d"),
        require("none-ls.code_actions.eslint_d"),
      },
    })

    vim.keymap.set("n", "<leader>ll", vim.lsp.buf.format, {})
  end,
}
