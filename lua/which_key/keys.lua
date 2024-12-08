-- 需要注意有时候按键功能需要延迟加载, 尽管在 which-key 插件加载中已经延迟了一次,
-- 不然对应功能都没有加载上来就试图绑定会报错.
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
local wk = require("which-key")
wk.add({{
    "<leader>?",
    function()
        wk.show({
            global = false
        })
    end,
    desc = "Keymaps Local (which-key)"
}, {
    "<leader>/",
    function()
        wk.show({
            global = true
        })
    end,
    desc = "Keymaps Global",
    icon = ""
}})

wk.add({ -- 保存文件.
    "<leader>w",
    "<Cmd>w<CR>",
    desc = "Save File",
    icon = ""
})

if not vim.g.vscode then
    -- nvim-tree.lua
    local nvim_tree_api = require("nvim-tree.api")
    wk.add { -- 切换文件侧边栏.
        "<leader>e",
        function()
            if nvim_tree_api.tree.is_visible({
                any_tabpage = true
            }) and nvim_tree_api.tree.is_tree_buf() then
                nvim_tree_api.tree.close()
            else
                nvim_tree_api.tree.open()
            end
        end,
        desc = "Toggle Explorer",
        mode = "n"
    }
    -- bufferline.nvim
    local bufferline = require("bufferline")
    wk.add { -- Buffer 操作.
        "<leader>b",
        mode = "n",
        group = "BufferLine",
        icon = "󱔗",
        { -- 转到左边的 Buffer.
            "<leader>bh",
            "<Cmd>BufferLineCyclePrev<CR>",
            {"<A-,>", "<Cmd>BufferLineCyclePrev<CR>"},
            desc = "Buffer on Left",
            icon = "󰙤"
        },
        { -- 转到右边的 Buffer.
            "<leader>bl",
            "<Cmd>BufferLineCycleNext<CR>",
            {"<A-.>", "<Cmd>BufferLineCycleNext<CR>"},
            desc = "Buffer on Right",
            icon = "󰙢"
        },
        { -- 当前 Buffer 向左移.
            "<leader>bj",
            "<Cmd>BufferLineMovePrev<CR>",
            {"<A-<>", "<Cmd>BufferLineMovePrev<CR>"},
            desc = "Buffer Move Left",
            icon = ""
        },
        { -- 当前 Buffer 向右移.
            "<leader>bk",
            "<Cmd>BufferLineMoveNext<CR>",
            {"<A->>", "<Cmd>BufferLineMoveNext<CR>"},
            desc = "Buffer Move Right",
            icon = ""
        },
        { -- 切换标签页固定状态.
            "<leader>bm",
            "<Cmd>BufferLineTogglePin<CR>",
            desc = "Pin Buffer",
            icon = ""
        },
        { -- 快速选中 Buffer.
            "<leader>bp",
            "<Cmd>BufferLinePick<CR>",
            desc = "Pick Buffer",
            icon = "󰷺"
        },
        { -- 关闭 Buffer.
            "<leader>bc",
            function()
                if vim.bo.modified then
                    -- 询问.
                    local choise = vim.fn.confirm('Buffer modified, sure to close?', '&Yes,\n&No\nor &Write and close',
                        3)
                    if choise == 1 then
                        bufferline.unpin_and_close()
                    elseif choise == 3 then
                        -- 先写入文件, 使用代码安静写入.
                        local bufnr = vim.api.nvim_get_current_buf()
                        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                        local filename = vim.api.nvim_buf_get_name(bufnr)
                        vim.fn.writefile(lines, filename)
                        vim.bo.modified = false -- 标记已经写入.
                        -- 关闭缓冲区.
                        bufferline.unpin_and_close()
                    end
                else
                    bufferline.unpin_and_close()
                end
            end,
            desc = "Close Buffer",
            icon = "󰅙"
        },
    }
	for i = 1, 5 do -- 切换到指定序号的 Buffer.
		wk.add({
			"<A-" .. i .. ">",
			"<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
			desc = "Go to Buffer " .. i,
			icon = "󰴍"
		})
	end
end
