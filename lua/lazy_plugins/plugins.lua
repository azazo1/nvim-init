local p = {}
table.insert(p, {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs") -- 这里不直接使用 opts 的原因是这里的模块名和插件的模块名不同.
        configs.setup({
            ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "javascript", "html", "markdown",
                                "markdown_inline", "rust", "python", "cpp", "json", "toml"},
            sync_install = false,
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end,
    cond = not vim.g.vscode
})
table.insert(p, {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    opts = { -- 通过 opts 参数直接传递给 `require("nvim-tree").setup`.
        sort = {
            sorter = "case_sensitive"
        },
        view = {
            width = 30
        },
        renderer = {
            group_empty = true
        },
        actions = {
            open_file = {
                quit_on_open = true
            }
        },
        filters = {
            dotfiles = true
        }
    },
    cond = not vim.g.vscode
})
table.insert(p, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- see: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
        delay = 1000 -- 按下按键后显示提示的延迟时间.
    },
    dependencies = {
        'echasnovski/mini.nvim',
        version = '*'
    },
    keys = function() -- 延迟加载, 防止有些键位对应插件没有加载到.
        require("which_key.keys")
        return {} -- 懒得摆了, 就放在这把.
    end
})
table.insert(p, {
    'wakatime/vim-wakatime',
    lazy = false,
    cond = not vim.g.vscode
})
table.insert(p, {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.cmd [[colorscheme tokyonight]] -- 指定特定的主题.
    end
})
table.insert(p, {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    opts = {
        options = {
            -- theme = 'tokyonight-moon' -- lualine 会自动继承全局的 colorScheme, 这里不写也可以.
            globalstatus = true -- 始终占据全屏宽度.
        },
        sections = {
            lualine_a = {function()
                return "" -- neovim 的图标, 需要 nerd font.
            end}
        }
    },
    cond = not vim.g.vscode
})
table.insert(p, {
    'akinsho/bufferline.nvim',
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup {
            options = {
                style_preset = bufferline.style_preset.no_italic,
                -- indicator = {
                --     style = "underline" -- 效果不好, 下划线会有偏移.
                -- }
                numbers = "ordinal", -- 显示序号.
                offsets = {{ -- 文件树打开自动偏移.
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "center",
                    separator = true
                }},
                show_buffer_close_icons = false,
                show_close_icon = false
            }
        }
    end,
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    cond = not vim.g.vscode
})
table.insert(p, {
    "lewis6991/gitsigns.nvim",
    opts = {},
    cond = not vim.g.vscode
})
table.insert(p, {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {'nvim-lua/plenary.nvim', -- required.
    'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' -- 下面这两个不是放在这,
    -- 而是要下载这个仓库的可执行文件,
    -- 放到环境目录中.
    -- 'BurntSushi/ripgrep',
    -- 'sharkdp/fd'
    },
    opts = {},
    cond = not vim.g.vscode
})
table.insert(p, {
    "NeogitOrg/neogit",
    dependencies = {"nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim" -- optional
    -- "ibhagwan/fzf-lua", -- optional
    -- "echasnovski/mini.pick" -- optional
    },
    opts = {
        -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
        -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
        -- normal mode.
        disable_insert_on_commit = true,
        -- "ascii"   is the graph the git CLI generates
        -- "unicode" is the graph like https://github.com/rbong/vim-flog, 也就是说要装一个字体.
        -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty, 也就是说要安装一个 Kitty 终端.
        graph_style = "ascii",
        -- Change the default way of opening neogit, floating is not implemented.
        kind = "tab"
    },
    cond = not vim.g.vscode
})
return p
