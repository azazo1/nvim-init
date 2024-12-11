if not vim.g.vscode then
	-- neo-tree.lua
	local wk = require("which-key")
	wk.add {
		"<leader>e",
		mode = "n",
		group = "Explorer",
		icon = "󱏒",
		{ -- 切换文件树打开与关闭.
			"<leader>ee",
			"<Cmd>Neotree toggle<CR>",
			desc = "Toggle Explorer",
			{"<A-e>", "<Cmd>Neotree toggle<CR>"}
		}, { -- 打开文件树并聚焦到当前的 buffer 所在的文件位置.
			"<leader>eE",
			"<Cmd>Neotree reveal<CR>",
			desc = "Open and Find Current File",
		}, { -- 在指定目录中打开文件树.
			"<leader>er",
			function()
                -- 使用 vim.ui.input
                vim.ui.input({
                    prompt = "Path to Open: ",
                    default = vim.fn.expand("%:p:h"),
                    completion = "file"
                }, function(user_input)
                    if user_input then
                        -- 如果用户没有取消.
						vim.cmd('Neotree dir=' .. user_input)
					end
                end)
			end,
			desc = "Open at Specific Path",
		}
	}
end
