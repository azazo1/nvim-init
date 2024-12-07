-- 需要注意有时候按键功能需要延迟加载, 尽管在 which-key 插件加载中已经延迟了一次,
-- 不然对应功能都没有加载上来就试图绑定会报错.
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
local k = {{
    "<leader>?",
    function()
        require("which-key").show({
            global = false
        })
    end,
    desc = "Buffer Local Keymaps (which-key)"
}}

if not vim.g.vscode then
    local nvim_tree_api = require("nvim-tree.api")
    table.insert(k, {
        "<leader>e",
        nvim_tree_api.tree.toggle,
        desc = "Toggle Explorer",
        mode = "n"
    })
end

return k
