if not vim.g.vscode then
	local wk = require("which-key")
	wk.add {
		"<leader>m",
		"<Cmd>Mason<CR>",
		desc = "Open Mason",
		icon = "",
	}
end
