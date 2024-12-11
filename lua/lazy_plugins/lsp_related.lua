-- LSP 相关的插件.
local p = {}
table.insert(p, {
    "williamboman/mason.nvim",
	cond = not vim.g.vscode
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
            ensure_installed = { -- 确保要安装的 LSP.
				"lua_ls", "pyright", "rust_analyzer"
			},
            automatic_installation = true
        }
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name) -- default handler (optional), 默认 LSP 配置设置.
				local capabilities = require('cmp_nvim_lsp').default_capabilities()
                require("lspconfig")[server_name].setup {
					capabilities = capabilities,
				}
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ["rust_analyzer"] = function()
            --     require("rust-tools").setup {}
            -- end
			-- 下面是自定义 LSP 配置的设置.
            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
				local capabilities = require('cmp_nvim_lsp').default_capabilities()
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {"vim"}
                            }
                        }
                    },
					capabilities = capabilities
                }
            end
        }
    end,
    cond = not vim.g.vscode
})

local kind_icons = {
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

table.insert(p, { -- 自动补全相关设置
    "hrsh7th/nvim-cmp",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline'
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup {
			-- todo: 不知道怎么让其只匹配光标之前的内容, 比如 >python import o<cursor>sdf 提示 os.
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						buffer = "[Buffer]",
						spell = "[Spell]",
						path = "[Path]"
					})[entry.source.name]
					return vim_item
				end,
			},
            sources = cmp.config.sources({
                { name = 'nvim_lsp' }, -- 自动补全 lsp 提供的内容.
                { name = "path" }, -- 自动补全路径.
                -- { name = "vsnip" }, -- snippets, https://github.com/hrsh7th/vim-vsnip
				{ name = "cmdline" }, -- 命令行自动补全
            }, {
				{ name = "buffer" }
			}),
            mapping = cmp.mapping.preset.insert({
                -- ['<C-Space>'] = cmp.mapping.complete(), -- 实际上没有必要, <C-n> 和 <C-p> 就能直接唤出.
                ['<C-e>'] = cmp.mapping.abort(), -- 关闭当前出现的补全
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 确认补全, Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                -- ['<Tab>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }), -- 影响缩进, 不用了.
            }),
			window = { -- 代码提示的窗口带边框.
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			experimental = { -- 代码提示在光标之后的虚拟文字.
				ghost_text = true
			}
        }
		local opts = {
			mapping = cmp.mapping.preset.cmdline(), -- 覆盖原生提示的键位, 达到禁用原生提示的作用.
			sources = {
				{ name = "buffer" }
			}
		}
		cmp.setup.cmdline('?', opts)
		cmp.setup.cmdline('/', opts)
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(), -- 同上.
			sources = cmp.config.sources({
				{ name = "cmdline" }
			}, {
				{ name = "path" }
			})
		})
    end,
    cond = not vim.g.vscode
})
table.insert(p, {
	"nvim-lua/lsp-status.nvim",
	config = function()
		require('lsp-status').register_progress()
	end,
	cond = not vim.g.vscode
})
return p
