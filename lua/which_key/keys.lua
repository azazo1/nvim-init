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
            vim.cmd [[cd]]
        end,
        desc = "Toggle Explorer",
        mode = "n"
    }
    wk.add { -- 关闭文件侧边栏.
        "<leader>E",
        nvim_tree_api.tree.close,
        desc = "Close Explorer",
        mode = "n"
    }
    -- bufferline.nvim
    local bufferline = require("bufferline")
    local close_buffer_asking = function(buf)
        -- 关闭缓冲区, 并带有相应的询问.
        -- 如果参数不提供, 默认使用当前的缓冲区.
        -- 返回关闭操作是否真正执行.
        buf = buf or vim.api.nvim_get_current_buf()
        if vim.api.nvim_get_option_value('modified', {
            buf = buf
        }) then
            -- 询问.
            local filename = vim.api.nvim_buf_get_name(buf)
            local choise = vim.fn.confirm(filename .. '\nBuffer modified, sure to close?',
                '&Yes,\n&No\nor &Write and close', 3)
            if choise == 1 then -- 强制关闭.
                vim.api.nvim_set_option_value('modified', false, {
                    buf = buf
                })
                bufferline.unpin_and_close(buf)
            elseif choise == 3 then
                -- 先写入文件, 使用代码安静写入.
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                vim.fn.writefile(lines, filename)
                vim.api.nvim_set_option_value('modified', false, {
                    buf = buf
                }) -- 标记已经写入.
                -- 关闭缓冲区.
                bufferline.unpin_and_close(buf)
            else
                return false
            end
        else -- 缓冲区没有修改.
            bufferline.unpin_and_close(buf)
        end
        return true
    end
    local get_valid_buffers = function()
        -- 获取当前有效的缓冲区.
        local t = {}
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(b) then
                table.insert(t, b)
            end
        end
        return t
    end
    wk.add { -- Buffer 操作.
        "<leader>b",
        mode = "n",
        group = "BufferLine",
        icon = "󱔗",
        { -- 转到左边的 Buffer.
            "<leader>bh",
            "<Cmd>BufferLineCyclePrev<CR>",
            {
                "<A-,>",
                "<Cmd>BufferLineCyclePrev<CR>",
                mode = {"n", "i"}
            },
            desc = "Go to Buffer on Left",
            icon = "󰙤"
        },
        { -- 转到右边的 Buffer.
            "<leader>bl",
            "<Cmd>BufferLineCycleNext<CR>",
            {
                "<A-.>",
                "<Cmd>BufferLineCycleNext<CR>",
                mode = {"n", "i"}
            },
            desc = "Go to Buffer on Right",
            icon = "󰙢"
        },
        { -- 当前 Buffer 向左移.
            "<leader>bj",
            "<Cmd>BufferLineMovePrev<CR>",
            {
                "<A-<>",
                "<Cmd>BufferLineMovePrev<CR>",
                mode = {"n", "i"}
            },
            desc = "Buffer Move Left",
            icon = ""
        },
        { -- 当前 Buffer 向右移.
            "<leader>bk",
            "<Cmd>BufferLineMoveNext<CR>",
            {
                "<A->>",
                "<Cmd>BufferLineMoveNext<CR>",
                mode = {"n", "i"}
            },
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
            close_buffer_asking,
            desc = "Close Buffer",
            icon = "󰅙",
            { -- 关闭当前 Buffer 并尝试退出.
                "<leader>q",
                function()
                    if (vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" -- 当前缓冲区是无名缓冲区.
                    and not vim.bo.modified -- 当前无名缓冲区没有被修改过.
                    ) then
                        vim.cmd [[q]]
                    else
                        close_buffer_asking()
                    end
                end,
                desc = "Close Buffer and Quitting"
            },
            { -- 关闭所有 Buffer 并退出, 相当于 <^-w>q 快捷键, 但是有提示功能.
                "<leader>Q",
                function()
                    local quit = true
                    for _, b in ipairs(get_valid_buffers()) do
                        if not close_buffer_asking(b) then
                            quit = false -- 有一个取消就中断.
                            break
                        end
                    end
                    if quit then
                        vim.cmd [[q]]
                    end
                end,
                desc = "Close All Buffer and Quitting"
            }
        }
    }
    for i = 1, 5 do -- 切换到指定序号的 Buffer.
        wk.add {
            "<A-" .. i .. ">",
            "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
            desc = "Go to Buffer " .. i,
            icon = "󰴍",
            mode = {"n", "i"}
        }
    end
    -- gitsigns.nvim
    local gitsigns = require("gitsigns")
    wk.add { -- GitSigns 操作
        "<leader>h",
        mode = {"n"},
        group = "GitSigns",
        icon = "",
        { -- 比较当前文件的修改.
            "<leader>hd",
            gitsigns.diffthis,
            desc = "Diff This",
            icon = ""
        },
        { -- 查看 blame.
            "<leader>hb",
            gitsigns.blame,
            desc = "Blame",
            icon = ""
        },
        { -- 查看改动块, 激活两次进入改动快窗口内部进行查看与复制.
            "<leader>hc",
            gitsigns.preview_hunk,
            desc = "Preview Hunk",
            icon = "󱀂"
        },
        { -- 暂存/取消暂存改动块.
            "<leader>hs",
            gitsigns.stage_hunk,
            desc = "Stage Hunk",
            icon = "󱖫"
        },
        { -- 暂存 Buffer.
            "<leader>hS",
            gitsigns.stage_buffer,
            desc = "Stage Buffer",
            icon = "󰷥",
        },
        { -- 取消此改动块的更改.
            "<leader>hr",
            gitsigns.reset_hunk,
            desc = "Reset Hunk",
            icon = "󰕍"
        },
        { -- 取消此 Buffer 中的更改.
            "<leader>hR",
            gitsigns.reset_buffer,
            desc = "Reset Buffer",
            icon = ""
        }
    }
end
