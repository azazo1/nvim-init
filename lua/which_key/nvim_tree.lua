if not vim.g.vscode then
    -- nvim-tree.lua
    local nvim_tree_api = require("nvim-tree.api")
    local wk = require("which-key")
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
        { -- 在当前 Buffer 的目录中打开文件树.
            "<leader>eE",
            function()
                local path = vim.api.nvim_buf_get_name(0)
                if not path then
                    vim.notify("Not a valid file", vim.log.levels.ERROR)
                    return
                end
                local state, result = pcall(nvim_tree_api.tree.find_file, {
                    buf = path,
                    open = true,
                    focus = true,
                    update_root = true
                })
                if not state then
                    vim.notify(result, vim.log.levels.ERROR)
                else
                    vim.print(path)
                end
            end,
            desc = "Open and Find Current File"
        },
        { -- 在指定目录中打开我文件树.
            "<leader>er",
            function()
                -- 使用 vim.ui.input
                local path = vim.ui.input({
                    prompt = "Path to Open: ",
                    default = vim.fn.expand("%:p:h")
                }, function(user_input)
                    if user_input then
                        -- 如果用户没有取消.
                        local state, result = pcall(nvim_tree_api.tree.open, {
                            path = path
                        })
                        if not state then
                            vim.notify(result, vim.log.levels.ERROR)
                        else
                            vim.print(path)
                        end
                    end
                end)
            end,
            desc = "Open on Specific Path"
        }
    }
end
