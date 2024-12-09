if not vim.g.vscode then
    -- neogit
    local wk = require("which-key")
    wk.add {
        "<leader>n",
        mode = "n",
        group = "Neogit",
        icon = "",
        {
            "<leader>nn",
            "<Cmd>Neogit<CR>",
            desc = "Open Neogit",
            icon = "󰊢"
        },
        {
            "<leader>nc",
            "<Cmd>Neogit commit<CR>",
            desc = "Neogit Commit Popup",
            icon = ""
        },
        {
            "<leader>nb",
            "<Cmd>Neogit branch<CR>",
            desc = "Neogit Branch Popup",
            icon = ""
        },
        {
            "<leader>nP",
            "<Cmd>Neogit push<CR>",
            desc = "Neogit Push Popup",
            icon = "",
        },
        {
            "<leader>np",
            "<Cmd>Neogit pull<CR>",
            desc = "Neogit Pull Popup",
            icon = "",
        },
        {
            "<leader>nr",
            "<Cmd>Neogit remote<CR>",
            desc = "Neogit Remote Config Popup",
            icon = "",
        },
        {
            "<leader>nl",
            "<Cmd>Neogit log<CR>",
            desc = "Neogit Log Popup",
            icon = "󱁉",
        },
        {
            "<leader>nm",
            "<Cmd>Neogit merge<CR>",
            desc = "Neogit Merge Popup",
            icon = "",
        }
    }
end
