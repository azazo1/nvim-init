-- disable netrw at the very start of your init.lua
-- netrw 是 vim 和 nvim 内置的文件浏览器, 这里直接禁用, 用 nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- 编码方式 utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
-- jkhl 移动时光标周围保留8行
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3
-- 显示行号
vim.wo.number = true
-- 使用相对行号
vim.wo.relativenumber = true
-- 高亮所在行
vim.wo.cursorline = true
-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"
-- 右侧参考线
vim.wo.colorcolumn = "85"
-- 缩进字符
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
-- >> << 时移动长度
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
-- 空格替代
-- tabvim.o.expandtab = true
vim.bo.expandtab = true
-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- 搜索大小写不敏感, 除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true
-- 搜索不要高亮
vim.o.hlsearch = false
vim.o.incsearch = true
-- 命令模式行高
vim.o.cmdheight = 1
-- 自动加载外部修改
vim.o.autoread = true
vim.bo.autoread = true
-- 禁止折行
vim.wo.wrap = false
-- 光标在行首尾时<Left><Right>可以跳到下一行
-- vim.o.whichwrap = "<,>,[,]"
-- 允许隐藏被修改过的buffer
-- vim.o.hidden = false
-- 鼠标支持
vim.o.mouse = "a"
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.splitbelow = true
vim.o.splitright = true
-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 不可见字符的显示, 这里只把空格显示为一个点
vim.o.list = true
vim.o.listchars = "space:·,tab:>-"
vim.o.wildmenu = true
vim.o.shortmess = vim.o.shortmess .. "c"
-- 补全显示10行
vim.o.pumheight = 10
-- 剪贴板和寄存器绑定
vim.o.clipboard = "unnamedplus"
-- lazy.nvim
require("config.lazy")
require("switch_ime.switch")
-- 和 lazy.nvim 不能同时开启.
-- require("config.vim-plug") -- 如果要启用这行, 需要先安装 vim-plug, 去官网看.
