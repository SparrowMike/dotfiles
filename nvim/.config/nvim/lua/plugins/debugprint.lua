local js_like = {
	left = 'console.info("',
	right = '")',
	mid_var = '", ',
	right_var = ")",
}

return {
	"andrewferrier/debugprint.nvim",
	opts = {
		filetypes = {
			["javascript"] = js_like,
			["javascriptreact"] = js_like,
			["typescript"] = js_like,
			["typescriptreact"] = js_like,
		},
		keymaps = {
			normal = {
				plain_below = ";db",
				plain_above = ";da",
				variable_below = ";dv",
				variable_above = ";dV",
				variable_below_alwaysprompt = "",
				variable_above_alwaysprompt = "",
				surround_plain = "g?sp",
				surround_variable = "g?sv",
				surround_variable_alwaysprompt = "",
				textobj_below = "g?o",
				textobj_above = "g?O",
				textobj_surround = "g?so",
				toggle_comment_debug_prints = "",
				delete_debug_prints = "",
			},
			insert = {
				plain = "<C-G>p",
				variable = "<C-G>v",
			},
			visual = {
				plain_below = ";db",
				plain_above = ";da",
				variable_below = "g?v",
				variable_above = "g?V",
				variable_below_alwaysprompt = ";dv",
				variable_above_alwaysprompt = ";dV",
				surround_plain = "g?sp",
				surround_variable = "g?sv",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
			reset_debug_prints_counter = "ResetDebugPrintsCounter",
		},
	},
}
