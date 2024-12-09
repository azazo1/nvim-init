if not vim.g.vscode then
    -- bufferline.nvim
    local bufferline = require("bufferline")
    local wk = require("which-key")
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
                pcall(bufferline.unpin_and_close, buf)
            elseif choise == 3 then
                -- 先安静写入文件, 如果报错了再提醒.
                local status, result = pcall(vim.cmd, [[silent w]])
                if not status then
                    vim.notify(result, vim.log.levels.ERROR)
                    return false -- 如果写入失败, 直接返回没有执行关闭操作.
                end
                -- 关闭缓冲区.
                pcall(bufferline.unpin_and_close, buf)
            else
                return false
            end
        else -- 缓冲区没有修改.
            pcall(bufferline.unpin_and_close, buf)
        end
        return true
    end
    local get_expected_buffers = function()
        -- 获取当前打开的缓冲区, 会跳过文件树 Buffer 界面.
        local t = {}
        for _, e in ipairs(bufferline.get_elements().elements) do
            table.insert(t, e.id)
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
                    if (#get_expected_buffers() == 1 -- 只有一个有效且被加载的 buffer.
                    and vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" -- 当前缓冲区是无名缓冲区.
                    and not vim.bo.modified -- 当前无名缓冲区没有被修改过.
                    ) then
                        vim.api
                            .nvim_feedkeys(vim.api.nvim_replace_termcodes("<Cmd>q<CR>", true, false, true), 'n', true)
                    else
                        close_buffer_asking()
                    end
                end,
                desc = "Close Buffer and Quitting"
            },
            { -- 关闭所有 Buffer 并退出 NeoVim, 如果有文件没有被修改, 则显示提示.
                "<leader>Q",
                function()
                    local quit = true
                    for _, b in ipairs(get_expected_buffers()) do
                        if not close_buffer_asking(b) then
                            quit = false -- 有一个取消就中断.
                            break
                        end
                    end
                    if quit then
                        vim.api.nvim_feedkeys(vim.api
                                                  .nvim_replace_termcodes("<Cmd>qa!<CR>", true, -- 是否启动键映射.
                            false, -- 是否在模式中等待.
                            true -- 是否支持特殊按键, 比如 <C-w>.
                        ), 'n', -- 模式 (normal).
                        true -- 是否立刻执行.
                        )
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
end
