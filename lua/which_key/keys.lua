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
    desc = "Buffer Local Keymaps (which-key)"
}, {
    "<leader>/",
    function()
        wk.show({
            global = true
        })
    end,
    desc = "Global Keymaps",
    icon = string.char(0xf3, 0xb0, 0x87, 0xa7)
}})

wk.add({
    "<leader>w",
    "<Cmd>w<CR>",
    desc = "File Write"
})

if not vim.g.vscode then
    -- nvim-tree.lua
    local nvim_tree_api = require("nvim-tree.api")
    wk.add {
        "<leader>e",
        nvim_tree_api.tree.toggle,
        desc = "Toggle Explorer",
        mode = "n"
    }
    -- barbar.nvim
    wk.add {
        "<leader>b",
        mode = "n",
        noremap = true,
        group = "[barbar] Buffer",
        icon = string.char(0xf3, 0xb1, 0x80, 0xb2),
        { -- 切换到左边的 Buffer.
            "<leader>bh",
            "<Cmd>BufferPrevious<CR>",
            desc = "Previous Buffer",
            icon = string.char(0xf3, 0xb0, 0xad, 0x8b),
            {"<A-,>", "<Cmd>BufferPrevious<CR>"} -- 子按键, 实现同样的功能.
        },
        { -- 切换到右边的 Buffer.
            "<leader>bl",
            "<Cmd>BufferNext<CR>",
            desc = "Next Buffer",
            icon = string.char(0xf3, 0xb0, 0x9d, 0x9c),
            {"<A-.>", "<Cmd>BufferNext<CR>"}
        },
        { -- 向左移动.
            "<leader>bj",
            "<Cmd>BufferMovePrevious<CR>",
            desc = "Move to Previous Buffer",
            icon = string.char(0xee, 0xaa, 0x9b),
            {"<A-<>", "<Cmd>BufferMovePrevious<CR>"}
        },
        { -- 向右移动.
            "<leader>bk",
            "<Cmd>BufferMoveNext<CR>",
            desc = "Move to Next Buffer",
            icon = string.char(0xee, 0xaa, 0x9c),
            {"<A->>", "<Cmd>BufferMoveNext<CR>"}
        },
        { -- 关闭当前缓冲区.
            "<leader>bc",
            function()
                if vim.bo.modified then
                    -- 询问.
                    local choise = vim.fn.confirm('Buffer modified, sure to close?', '&Yes,\n&No\nor &Write and close',
                        3)
                    if choise == 1 then
                        vim.cmd [[BufferClose!]]
                    elseif choise == 3 then
                        -- 先写入文件, 使用代码安静写入.
                        local bufnr = vim.api.nvim_get_current_buf()
                        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                        local filename = vim.api.nvim_buf_get_name(bufnr)
                        vim.fn.writefile(lines, filename)
                        vim.bo.modified = false -- 标记已经写入.
                        -- 关闭缓冲区.
                        vim.cmd [[BufferClose]]
                    end
                else
                    vim.cmd [[BufferClose]]
                end
            end,
            desc = "Close Buffer",
            icon = string.char(0xf3, 0xb0, 0x85, 0x99)
        },
        { -- 跳转 Buffer.
            "<leader>bj",
            "<Cmd>BufferJump<CR>",
            desc = "Jump to Buffer",
            icon = string.char()
        }
    }
end
