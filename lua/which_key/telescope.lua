if not vim.g.vscode then
    -- telescope.nvim
    -- picker 中的键位见 plugins.lua 中 telescope 的 setup.
    local telescope_builtin = require("telescope.builtin")
    local wk = require("which-key")
    wk.add { -- Telescope 操作.
        "<leader>f",
        mode = "n",
        group = "Telescope",
        icon = "",
        { -- Telescope 界面.
            "<leader>ff",
            "<Cmd>Telescope<CR>",
            desc = "Telescope Builtin",
            icon = ""
        },
        { -- 查找文件.
            "<leader>fd",
            "<Cmd>Telescope find_files<CR>",
            desc = "Find Files",
            icon = "󰈞"
        },
        { -- 实时查找内容. todo 继承上一次搜索的内容.
            "<leader>fg",
            "<Cmd>Telescope live_grep<CR>",
            desc = "Live Grep",
            icon = ""
        },
        { -- 实时查找光标下的内容.
            "<leader>fc",
            function()
                telescope_builtin.grep_string({
                    use_regex = true
                })
            end,
            desc = "Grep Cursor Word",
            icon = "󰗧"
        },
        { -- 查看所有键位.
            "<leader>fk",
            "<Cmd>Telescope keymaps<CR>",
            desc = "Keymaps",
            icon = ""
        },
        { -- 查看帮助文档列表.
            "<leader>fh",
            "<Cmd>Telescope help_tags<CR>",
            desc = "Help Docs",
            icon = "󰈙"
        },
        { -- 打开上一次的 picker, picker 指的就是弹出来的窗口, 会保存打开的状态.
            "<leader>fl",
            "<Cmd>Telescope resume<CR>",
            desc = "Last Picker",
            icon = ""
        },
        { -- 打开 picker 历史记录, 历史记录的数量见 telescope.defaults.cache_picker.
            "<leader>fp",
            "<Cmd>Telescope pickers<CR>",
            desc = "Pickers Used",
            icon = ""
        },
        { -- 打开光标跳转记录.
            "<leader>fj",
            "<Cmd>Telescope jumplist<CR>",
            desc = "Jumplist",
            icon = "󰽒"
        },
        { -- 和 scope.nvim 联动, 搜索所有 tabs 中打开的 Buffer.
            "<leader>fb",
            "<Cmd>Telescope scope buffers<CR>",
            desc = "Search All Buffers",
            icon = "󰓩"
        }
    }
end
