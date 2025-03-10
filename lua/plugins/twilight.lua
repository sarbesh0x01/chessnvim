-- Add to lua/plugins/twilight.lua
return {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
        { "<leader>tw", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
    opts = {
        dimming = {
            alpha = 0.25, -- Amount of dimming
            color = { "Normal", "#ffffff" },
            term_bg = "#000000", -- Terminal background color
            inactive = true, -- Dim inactive windows
        },
        context = 10, -- Lines to keep focused around cursor
        treesitter = true, -- Use treesitter for better code parsing
        -- Highlight groups to exclude from dimming
        exclude = { "Comment", "String", "DiagnosticError", "DiagnosticWarn" },
        expand = { -- Expand context for these language nodes
            "function",
            "method",
            "table",
            "if_statement",
            "for_statement",
            "while_statement",
        },
    },
}
