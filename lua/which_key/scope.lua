if not vim.g.vscode then
    -- scope.nvim
    local wk = require("which-key")
    wk.add {
        "<leader>t",
        mode = "n",
        group = "Tabs Scope",
        icon = "󰓩",
        {
            "<leader>tN",
            "<Cmd>tabnew<CR>",
            desc = "New Tab"
        },
        {
            "<leader>tn",
            "<Cmd>tabnext<CR>",
            desc = "Next Tab"
        },
        {
            "<leader>tp",
            "<Cmd>tabprev<CR>",
            desc = "Prev Tab"
        },
        {
            "<leader>tq",
            "<Cmd>tabclose<CR>",
            desc = "Close Tab"
        }
    }
end
