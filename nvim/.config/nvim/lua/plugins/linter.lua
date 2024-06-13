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

    vim.keymap.set("n", "<leader>ll", function()
      vim.lsp.buf.format()

      -- Check if Tailwind CSS LSP client is active for the current buffer
      local clients = vim.lsp.get_clients()
      local tailwind_active = false
      for _, client in ipairs(clients) do
        if client.name == "tailwindcss" then
          tailwind_active = true
          break
        end
      end

      -- Run TailwindSort if Tailwind LSP client is active
      if tailwind_active then
        vim.cmd(":TailwindSort")
      end
    end, { desc = "Format buffer and Tailwind sort" })
  end,
}
