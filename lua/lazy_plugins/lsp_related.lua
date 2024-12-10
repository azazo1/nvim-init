-- LSP 相关的插件.
local p = {}
table.insert(p, {
    "williamboman/mason.nvim",
    config = not vim.g.vscode
})
table.insert(p, {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode
})
table.insert(p, {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        -- require 的顺序就要这样放.
        require("mason").setup()
        require("mason-lspconfig").setup {
            ensure_installed = {"lua_ls"},
            automatic_installation = true
        }
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {}
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ["rust_analyzer"] = function()
            --     require("rust-tools").setup {}
            -- end
            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {"vim"}
                            }
                        }
                    }
                }
            end
        }
    end,
    cond = not vim.g.vscode
})
table.insert(p, { -- 自动补全相关设置
    "hrsh7th/nvim-cmp",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path'
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup {
            sources = cmp.config.sources({
                { name = 'nvim_lsp' }, -- 自动补全 lsp 提供的内容.
                { name = "path" }, -- 自动补全路径.
                -- { name = "vsnip" }, -- snippets, https://github.com/hrsh7th/vim-vsnip
                { name = "buffer" }
            }),
            mapping = cmp.mapping.preset.insert({
                -- ['<C-Space>'] = cmp.mapping.complete(), -- 实际上没有必要, <C-n> 和 <C-p> 就能直接唤出.
                ['<C-c>'] = cmp.mapping.abort(), -- 关闭当前出现的补全
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 确认补全, Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<Tab>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
            }),
        }
    end,
    cond = not vim.g.vscode
})
return p
