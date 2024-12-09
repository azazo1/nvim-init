if not vim.g.vscode then
    -- gitsigns.nvim
    local wk = require("which-key")
    local gitsigns = require("gitsigns")
    wk.add { -- GitSigns 操作
        "<leader>h",
        mode = {"n"},
        group = "GitSigns",
        icon = "",
        { -- 比较当前文件的修改 (与上一次 commit 比较).
            "<leader>hd",
            function()
                gitsigns.diffthis('~1')
            end,
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
            "<leader>hp",
            gitsigns.preview_hunk,
            desc = "Preview Hunk",
            icon = "󱀂"
        },
        { -- 跳转到上一个改动块.
            "<leader>hk",
            function()
                gitsigns.nav_hunk('prev', {
                    preview = true,
                    target = 'all',
                    wrap = true
                })
            end,
            desc = "Go to Previous Hunk",
            icon = ""
        },
        { -- 跳转到下一个改动块.
            "<leader>hj",
            function()
                gitsigns.nav_hunk('next', {
                    preview = true,
                    target = 'all',
                    wrap = true
                })
            end,
            desc = "Go to Next Hunk",
            icon = ""
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
            icon = "󰷥"
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
