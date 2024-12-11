if not vim.g.vscode then
	-- lsp related keymaps
	local wk = require("which-key")
	wk.add {
		"<leader>a",
		mode = "n",
		group = "LSP",
		icon = "󱠀",
		{
			"<leader>af",
			vim.lsp.buf.format,
			desc = "Format",
		},
		{
			"<leader>ah",
			vim.lsp.buf.completion,
			desc = "Completion",
		},
		{
			"<leader>ad",
			vim.lsp.buf.definition,
			desc = "Definition",
		},
		{
			"<leader>ar",
			vim.lsp.buf.rename,
			desc = "Rename",
		},
		{
			"<leader>ab",
			vim.lsp.buf.references,
			desc = "References",
		}
	}
end
