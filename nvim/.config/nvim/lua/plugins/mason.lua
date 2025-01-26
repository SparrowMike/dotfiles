return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy", -- Lazy-load Mason
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy", -- Lazy-load Mason LSP Config
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"rust_analyzer",
					"cssls",
					"html",
					"tailwindcss",
					"bashls",
					"jsonls",
					"emmet_ls",
				},
				-- automatic_installation = true, -- Automatically install LSP servers
			})
		end,
	},
}
