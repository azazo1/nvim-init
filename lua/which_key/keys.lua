-- 需要注意有时候按键功能需要延迟加载, 尽管在 which-key 插件加载中已经延迟了一次,
-- 不然对应功能都没有加载上来就试图绑定会报错.
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
local wk = require("which-key")
wk.add({{
    "<leader>?",
    function()
        wk.show({
            global = false
        })
    end,
    desc = "Keymaps Local (which-key)"
}, {
    "<leader>/",
    function()
        wk.show({
            global = true
        })
    end,
    desc = "Keymaps Global",
    icon = ""
}})

wk.add({ -- 保存文件.
    "<leader>w",
    "<Cmd>w<CR>",
    desc = "Save File",
    icon = ""
})

wk.add { -- 撤销操作.
	"<^-Z>",
	"<Cmd>u<CR>",
	desc = "Undo",
	icon = "",
	mode = "n",
}

wk.add { -- 显示当前文件信息.
	"<leader>i",
	"<Cmd>file<CR>",
	mode = "n",
	desc = "Show File Info",
	icon = "",
}

if not vim.g.vscode then
	-- 窗口焦点移动.
	wk.add {
		mode = {"i", "n"},
		group = "Move Focus",
		-- 这里需要确保命令在 normal 模式中执行.
		-- 所以需要使用 nvim_feedkeys.
		{ -- 向左.
			"<C-h>",
			function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-w>h", true, false, true
					),
					'n', true
				)
			end,
			desc = "Move Focus Left",
		},
		{ -- 向右.
			"<C-l>",
			function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-w>l", true, false, true
					),
					'n', true
				)
			end,
			desc = "Move Focus Right",
		},
		{ -- 向下.
			"<C-j>",
			function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-w>j", true, false, true
					),
					'n', true
				)
			end,
			desc = "Move Focus Down",
		},
		{ --向上.
			"<C-k>",
			function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-w>k", true, false, true
					),
					'n', true
				)
			end,
			desc = "Move Focus Up",
		}
	}
    -- nvim-tree.lua
    local nvim_tree_api = require("nvim-tree.api")
	local toggle_quit_on_open = function()
		local config = require('nvim-tree').config
		config.actions.open_file.quit_on_open = not config.actions.open_file.quit_on_open
		require('nvim-tree').setup(config)
		if config.actions.open_file.quit_on_open then
			vim.print("nvim-tree will quit_on_open")
		else
			vim.print("nvim-tree will not quit_on_open")
		end
	end
	local toggle_explorer = function()
		-- 如果焦点不在文件树且文件树打开, 那么先不关闭, 先聚焦.
		if nvim_tree_api.tree.is_visible({
			any_tabpage = true
		}) and nvim_tree_api.tree.is_tree_buf() then
			nvim_tree_api.tree.close()
		else
			nvim_tree_api.tree.open()
		end
		vim.cmd [[cd]] -- 输出当前路径
	end
    wk.add { -- 文件树键位.
		"<leader>e",
		mode = "n",
		group = "Explorer",
		icon = "󱏒",
		{ -- 切换文件侧边栏打开与关闭.
			"<leader>ee",
			toggle_explorer,
			desc = "Toggle Explorer",
			{"<A-e>", toggle_explorer}
		},
		{ -- 切换: 文件树在打开文件后自动关闭.
			"<leader>eE",
			toggle_quit_on_open,
			desc = "Toggle Quit on Open",
		}
	}
    -- bufferline.nvim
    local bufferline = require("bufferline")
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
                -- 先写入文件, 使用代码安静写入.
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                vim.fn.writefile(lines, filename)
                vim.api.nvim_set_option_value('modified', false, {
                    buf = buf
                }) -- 标记已经写入.
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
                    if (
						#get_expected_buffers() == 1 -- 只有一个有效且被加载的 buffer.
						and vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" -- 当前缓冲区是无名缓冲区.
						and not vim.bo.modified -- 当前无名缓冲区没有被修改过.
                    ) then
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<Cmd>q<CR>", true, false, true),
							'n', true
						)
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
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<Cmd>qa!<CR>",
								true, -- 是否启动键映射.
								false, -- 是否在模式中等待.
								true -- 是否支持特殊按键, 比如 <C-w>.
							),
							'n', -- 模式 (normal).
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
    -- gitsigns.nvim
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
				gitsigns.nav_hunk('prev',
					{preview = true, target='all', wrap=true}
				)
			end,
			desc = "Go to Previous Hunk",
			icon = ""
		},
		{ -- 跳转到下一个改动块.
			"<leader>hj",
			function()
				gitsigns.nav_hunk('next',
					{preview = true, target='all', wrap=true}
				)
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
            icon = "󰷥",
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
	-- telescope.nvim
	local telescope_builtin = require("telescope.builtin")
	wk.add { -- Telescope 操作.
		"<leader>f",
		mode = "n",
		group = "Telescope",
		icon = "",
		{ -- Telescope 界面.
			"<leader>ft",
			"<Cmd>Telescope<CR>",
			desc = "Open Telescope Window",
			icon = "",
		},
		{ -- 查找文件.
			"<leader>ff",
			"<Cmd>Telescope find_files<CR>",
			desc = "Telescope Find Files",
			icon = "󰈞",
		},
		{ -- 实时查找内容.
			"<leader>fg",
			"<Cmd>Telescope live_grep<CR>",
			desc = "Telescope Live Grep",
			icon = "",
		},
		{ -- 实时查找光标下的内容.
			"<leader>fc",
			function()
				telescope_builtin.grep_string({
					use_regex = true
				})
			end,
			desc = "Grep Cursor Word",
			icon = "󰗧",
		}
	}
end
