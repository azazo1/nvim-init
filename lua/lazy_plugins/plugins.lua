local p = {}
table.insert(p, { -- 语法高亮.
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
table.insert(p, { -- 新版文件树.
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
	  -- 下面这个需要 luaroscks, 还需要在环境目录中又 lua 5.1, 暂时不用了.
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
	cond = not vim.g.vscode,
	opts = {
		close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
		window = {
			mappings = {
				['w'] = 'none', -- 取消使用 window-picker 打开的快捷键.
				['q'] = 'none', -- 取消使用 q 键退出.
				["/"] = "none", -- 取消模糊搜索.
			}
		},
	}
})
table.insert(p, { -- 键位设置与显示.
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
table.insert(p, { -- 计时器.
    'wakatime/vim-wakatime',
    lazy = false,
    cond = not vim.g.vscode
})
table.insert(p, { -- 主题.
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.cmd [[colorscheme tokyonight]] -- 指定特定的主题.
    end
})
table.insert(p, { -- 底部状态栏.
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
            end},
            lualine_c = {
                'filename',
                function()
                    local emoji = {"🚫", "⏸️ ", "⌛️", "⚠️ ", "0️⃣ ", "✅"}
                    return "🅕: " .. emoji[require("fittencode").get_current_status()]
                end
            },
			lualine_x = {'encoding', 'fileformat', 'filetype', 'require"lsp-status".status()'}
        }
    },
    cond = not vim.g.vscode
})
table.insert(p, { -- 顶部 Buffer 栏.
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
                    filetype = "neo-tree",
                    text = "File Explorer",
                    text_align = "center",
                    separator = true
                }},
                show_buffer_close_icons = false,
                show_close_icon = false,
				diagnostics = "nvim_lsp",
				separator_style = "slant" -- buffer 的标签页: 梯形.
			}
        }
    end,
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    cond = not vim.g.vscode
})
table.insert(p, { -- Buffer 内 git 变化查看.
    "lewis6991/gitsigns.nvim",
    opts = {},
    cond = not vim.g.vscode
})
table.insert(p, { -- 各种查找.
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {'nvim-lua/plenary.nvim', -- required.
    'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' -- 下面这两个不是放在这,
    -- 而是要下载这个仓库的可执行文件,
    -- 放到环境目录中.
    -- 'BurntSushi/ripgrep',
    -- 'sharkdp/fd'
    },
    config = function()
        local telescope = require('telescope')
        local actions = require("telescope.actions")
        telescope.setup({
            pickers = {
                live_grep = {
                    theme = "ivy" -- 以底部栏的形式出现.
                }
            },
            defaults = {
                cache_picker = { -- 保存的 picker 数量.
                    num_pickers = 2
                },
                mappings = {
                    i = {
                        -- 切换搜索历史.
                        ['<A-p>'] = actions.cycle_history_prev,
                        ['<A-n>'] = actions.cycle_history_next
                    }
                }
            }
        })
        telescope.load_extension("scope")
    end,
    cond = not vim.g.vscode
})
table.insert(p, { -- git 操作窗口.
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
        -- "ascii"   is the graph the git CLI generates, 这个也能显示不同的 branch 的情况, 只不过方正一点.
        -- "unicode" is the graph like https://github.com/rbong/vim-flog, 也就是说要装一个字体, 没什么必要, 也就是好看一点.
        -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty, 也就是说要安装一个 Kitty 终端.
        graph_style = "ascii",
        -- Change the default way of opening neogit, floating is not implemented.
        kind = "tab"
    },
    cond = not vim.g.vscode
})
table.insert(p, { -- 标签页 (tabs) 隔离 Buffer.
    "tiagovla/scope.nvim",
    opts = {},
    cond = not vim.g.vscode
})
table.insert(p, { -- 丝滑滚动.
    "karb94/neoscroll.nvim",
    opts = {
        duration_multiplier = 0.05, -- Global duration multiplier
        easing = "quadratic"
    },
    cond = not vim.g.vscode -- vscode 测试过了, 用不了.
})
table.insert(p, { -- 滚动进度条.
    'dstein64/nvim-scrollview',
    opts = {},
    cond = not vim.g.vscode
})
table.insert(p, { -- 粘性行.
    'nvim-treesitter/nvim-treesitter-context',
    opts = {},
    cond = not vim.g.vscode
})
local function table_expand(t1, t2)
    -- 将 t2 内容放到 t1 后面, 仅限数组类型的表.
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
end
table_expand(p, require("lazy_plugins.lsp_related"))
local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end
table.insert(p, { -- 自动保存.
	"Pocco81/auto-save.nvim",
	opts = {
		debounce_delay = 1000, -- saves the file at most every `debounce_delay` milliseconds
		trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
		condition = function(buf)
			local fn = vim.fn
			local utils = require("auto-save.utils.data")
			if fn.getbufvar(buf, "&modifiable") == 1 and
				utils.not_in(fn.getbufvar(buf, "&filetype"), {}) and
				file_exists(vim.api.nvim_buf_get_name(buf)) then
				return true -- met condition(s), can save
			end
			return false -- can't save
		end,
	},
	cond = not vim.g.vscode,
})
table.insert(p, { -- fitten code AI 自动补全
    'luozhiya/fittencode.nvim',
    opts = {},
    cond = not vim.g.vscode
})
return p
