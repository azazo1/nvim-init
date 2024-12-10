if not vim.g.vscode then
    -- nvim-treesitter-context
    local wk = require("which-key")
    local ctx = require("treesitter-context")
    wk.add {
        "<leader>u",
        function()
            ctx.go_to_context(vim.v.count1)
        end,
        icon = "󰞕",
        desc = "Jump Up to Sticky Line",
    }
end