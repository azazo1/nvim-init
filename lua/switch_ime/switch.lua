-- 自动切换英文, 仅在 Windows 生效, lua 中 0 也是 true.
if vim.fn.has('win32') == 0 then
    return
end

local ffi = require("ffi")
-- 定义需要的 Win32 API 和常量
ffi.cdef [[
typedef void* HWND;
typedef long LPARAM;
typedef unsigned int WPARAM;
typedef int BOOL;

HWND GetForegroundWindow();
BOOL PostMessageA(HWND hWnd, unsigned int Msg, WPARAM wParam, LPARAM lParam);

static const int WM_INPUTLANGCHANGEREQUEST = 0x0050;
]]

-- 加载 user32.dll
local user32 = ffi.load("user32.dll")

-- 切换输入法函数
local function switch_ime(locale)
    -- 获取当前前台窗口句柄
    local hwnd = user32.GetForegroundWindow()

    -- 将 locale 转换为 LPARAM 类型
    local currentLayout = ffi.cast("LPARAM", locale)
    user32.PostMessageA(hwnd, ffi.C.WM_INPUTLANGCHANGEREQUEST, 0, currentLayout)

    -- 发送 WM_INPUTLANGCHANGEREQUEST 消息
    -- local result = user32.PostMessageA(hwnd, ffi.C.WM_INPUTLANGCHANGEREQUEST, 0, currentLayout)
    -- 检查结果
    -- if result == 0 then
    --     print("Failed to send message")
    -- else
    --     print("Input method switched successfully")
    -- end
end

-- 示例：切换到英文（美国）输入法
-- locale 对应输入法的键盘布局（如 0x0409 是英文美国）
-- switch_ime(1033)

-- 退出 Insert 模式的时候切换为英文.
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        switch_ime(1033)
    end
})
-- 进入文件编辑的时候切换为英文.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        switch_ime(1033)
    end
})
-- 终端获取焦点的时候自动切换英文.
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		switch_ime(1033)
	end,
})
