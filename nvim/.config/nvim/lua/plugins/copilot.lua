return {
	-- 'github/copilot.vim',
	-- config = function()
	--     vim.keymap.set('n', '<leader>cp', ':copilot panel<cr>')

	-- vim.keymap.set('i', '<c-c>', 'copilot#accept("\\<cr>")', {
	-- vim.keymap.set('i', '<tab>', 'copilot#accept("\\<tab>")', {
	--     expr = true,
	--     replace_keycodes = false
	-- })
	-- vim.g.copilot_no_tab_map = true
	-- end

	{
		"Exafunction/codeium.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},

	{
		"Exafunction/codeium.vim",
		event = "InsertEnter",
		config = function()
			-- Add keybindings for Codeium functions here
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<C-c>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<C-v>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<C-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
	-- {
	-- 	"robitx/gp.nvim",
	-- 	config = function()
	-- 		local conf = {
	-- 			-- For customization, refer to Install > Configuration in the Documentation/Readme
	-- 		}
	-- 		require("gp").setup(conf)
	--
	-- 		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	-- 	end,
	-- },

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- set this if you want to always pull the latest change
		opts = {
		-- 	provider = "openai",
		-- 	providers = { "openai" },
		-- 	openai = {
		-- 		-- model = "gpt-3.5-turbo",
		-- 		-- model = "gpt-3.5-turbo-0125",
		-- 		-- model = "gpt-4-turbo",
		-- 		temperature = 0.3,
		-- 		max_tokens = 1000,
		-- 	},
			windows = {
				position = "left",
			},
		},

		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`

		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			{
				"nvim-tree/nvim-web-devicons",
				lazy = true,
			}, -- or echasnovski/mini.icons
			{
				"zbirenbaum/copilot.lua",
				event = "InsertEnter",
			},
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
