-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("x", "<leader>p", '"_d"+P', { desc = "Paste from system clipboard" })

local function ignore_function_key(lhs)
  pcall(vim.keymap.set, { "n", "x", "s", "o", "i", "c", "t" }, lhs, "<Nop>", {
    silent = true,
    desc = "Ignore function key",
  })
end

for key = 1, 24 do
  local key_name = "F" .. key
  local modifiers = { "S", "C", "M", "D" }
  local prefix = {}
  local used = {}

  ignore_function_key("<" .. key_name .. ">")

  local function map_modifier_orders()
    if #prefix > 0 then
      ignore_function_key("<" .. table.concat(prefix, "-") .. "-" .. key_name .. ">")
    end

    if #prefix == #modifiers then
      return
    end

    for _, modifier in ipairs(modifiers) do
      if not used[modifier] then
        used[modifier] = true
        prefix[#prefix + 1] = modifier
        map_modifier_orders()
        prefix[#prefix] = nil
        used[modifier] = nil
      end
    end
  end

  map_modifier_orders()
end
