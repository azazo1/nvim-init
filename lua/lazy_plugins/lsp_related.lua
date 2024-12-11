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
				"lua_ls", "pyright", "rust_analyzer", "texlab"
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
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-nvim-lua'
    },
    config = function()
		local cmp = require("cmp")
		cmp.setup {
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},
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
				{ name = "nvim_lua" }, -- nvim api 的补全.
                { name = 'nvim_lsp' }, -- 自动补全 lsp 提供的内容.
                { name = "path" }, -- 自动补全路径.
                -- { name = "vsnip" }, -- snippets, https://github.com/hrsh7th/vim-vsnip
				{ name = "cmdline" }, -- 命令行自动补全.
				-- { name = 'vsnip' }, -- For vsnip users.
				{ name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
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
				ghost_text = false -- 和 snippets 一起用的时候表现很奇怪, 不用了.
			}
        }
		local opts = {
			mapping = cmp.mapping.preset.cmdline(), -- 覆盖原生提示的键位, 达到禁用原生提示的作用.
			sources = {
				{ name = "buffer" }
			}
		}
		cmp.setup.cmdline({'?', '/'}, opts)
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
table.insert(p, {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.3.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	-- 如果是 Windows 用户, 需要自行修改 git 里的 sh 位置!!
	build = vim.fn.has("win32") ~= 0 and [[
		make install_jsregexp CC=gcc.exe SHELL="C:/Program Files/Git/bin/sh.exe" .SHELLFLAGS=-c
	]] or [[make install_jsregexp]],
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function ()
		require("luasnip.loaders.from_vscode").lazy_load()
	end
})
return p
