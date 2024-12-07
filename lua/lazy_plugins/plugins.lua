local p = {}
table.insert(p, {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
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
    config = function()
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive"
            },
            view = {
                width = 30
            },
            renderer = {
                group_empty = true
            },
            filters = {
                dotfiles = true
            }
        })
    end,
    cond = not vim.g.vscode
})
table.insert(p, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- see: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
        delay = 600 -- 按下按键后显示提示的延迟时间.
    },
    keys = require("which_key.keys")
})
table.insert(p, {
    'wakatime/vim-wakatime',
    lazy = false,
    cond = not vim.g.vscode
})
return p
