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
    desc = "Keymaps Local"
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

wk.add { -- 显示当前文件信息.
    "<leader>i",
    "<Cmd>file<CR>",
    mode = "n",
    desc = "Show File Info",
    icon = ""
}

if not vim.g.vscode then
    -- 窗口焦点移动.
    wk.add {
        mode = {"i", "n"},
        group = "Move Focus",
        { -- 向左.
            "<C-h>",
            "<Esc><C-w>h",
            desc = "Move Focus Left"
        },
        { -- 向右.
            "<C-l>",
            "<Esc><C-w>l",
            desc = "Move Focus Right"
        },
        { -- 向下.
            "<C-j>",
            "<Esc><C-w>j",
            desc = "Move Focus Down"
        },
        { -- 向上.
            "<C-k>",
            "<Esc><C-w>k",
            desc = "Move Focus Up"
        }
    }
end
require("which_key.nvim_tree")
require("which_key.bufferline")
require("which_key.gitsigns")
require("which_key.telescope")
