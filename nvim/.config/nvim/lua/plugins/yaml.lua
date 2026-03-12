return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>yo",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if file == "" then
            vim.notify("No file to preview", vim.log.levels.WARN)
            return
          end
          local out = vim.fn.tempname() .. ".html"
          vim.notify("Building OpenAPI docs...", vim.log.levels.INFO)
          vim.fn.jobstart({ "npx", "@redocly/cli", "build-docs", file, "-o", out }, {
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.ui.open(out)
                  vim.notify("OpenAPI preview opened", vim.log.levels.INFO)
                else
                  vim.notify("Redocly build failed (exit " .. code .. ")", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "OpenAPI preview (Redocly)",
      },
      {
        "<leader>yc",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if file == "" then
            vim.notify("No file to compile", vim.log.levels.WARN)
            return
          end
          local out = file:gsub("%.ya?ml$", "") .. ".html"
          vim.notify("Compiling OpenAPI → " .. vim.fn.fnamemodify(out, ":t") .. "...", vim.log.levels.INFO)
          vim.fn.jobstart({ "npx", "@redocly/cli", "build-docs", file, "-o", out }, {
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.notify("Compiled: " .. out, vim.log.levels.INFO)
                else
                  vim.notify("Compile failed (exit " .. code .. ")", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "OpenAPI compile to HTML",
      },
    },
  },
}
