if not vim.g.vscode then
    -- nvim-tree.lua
    local nvim_tree_api = require("nvim-tree.api")
    local wk = require("which-key")
    local toggle_quit_on_open = function()
        local config = require('nvim-tree').config
        config.actions.open_file.quit_on_open = not config.actions.open_file.quit_on_open
        require('nvim-tree').setup(config)
        if config.actions.open_file.quit_on_open then
            vim.print("nvim-tree will quit_on_open")
        else
            vim.print("nvim-tree will not quit_on_open")
        end
    end
    local toggle_explorer = function()
        -- 如果焦点不在文件树且文件树打开, 那么先不关闭, 先聚焦.
        if nvim_tree_api.tree.is_visible({
            any_tabpage = true
        }) and nvim_tree_api.tree.is_tree_buf() then
            nvim_tree_api.tree.close()
        else
            nvim_tree_api.tree.open()
        end
        vim.cmd [[cd]] -- 输出当前路径
    end
    wk.add { -- 文件树键位.
        "<leader>e",
        mode = "n",
        group = "Explorer",
        icon = "󱏒",
        { -- 切换文件侧边栏打开与关闭.
            "<leader>ee",
            toggle_explorer,
            desc = "Toggle Explorer",
            {"<A-e>", toggle_explorer}
        },
        { -- 切换: 文件树在打开文件后自动关闭.
            "<leader>eE",
            toggle_quit_on_open,
            desc = "Toggle Quit on Open"
        }
    }
end
