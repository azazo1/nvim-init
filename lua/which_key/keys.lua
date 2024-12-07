-- 需要注意有时候按键功能需要延迟加载,
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
    table.insert(k, {
        "<leader>e",
        function()
            -- 这里不使用调用 api 的方法,
            -- 因为好像 require 重复调用会很卡.
            vim.cmd [[
                NvimTreeToggle
            ]]
        end,
        desc = "Toggle Explorer",
        mode = "n"
    })
end

return k
