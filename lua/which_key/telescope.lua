if not vim.g.vscode then
    -- telescope.nvim
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
            desc = "Open Telescope Window",
            icon = ""
        },
        { -- 查找文件.
            "<leader>fd",
            "<Cmd>Telescope find_files<CR>",
            desc = "Telescope Find Files",
            icon = "󰈞"
        },
        { -- 实时查找内容. todo 继承上一次搜索的内容.
            "<leader>fg",
            "<Cmd>Telescope live_grep<CR>",
            desc = "Telescope Live Grep",
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
        }
    }
end
