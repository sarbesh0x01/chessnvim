return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary", -- More stable branch
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    cmd = {
        "CopilotChat",
        "CopilotChatToggle", 
        "CopilotChatReset",
    },
    keys = {
        { "<leader>cc", "<cmd>CopilotChat<CR>", desc = "Copilot Chat" },
        { "<leader>ct", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Chat Window" },
        { "<leader>cr", "<cmd>CopilotChatReset<CR>", desc = "Reset Chat" },
        -- Common actions as commands
        { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain Code", mode = { "n", "v" } },
        { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix Code", mode = { "n", "v" } },
        { "<leader>co", "<cmd>CopilotChatOptimize<CR>", desc = "Optimize Code", mode = { "n", "v" } },
        { "<leader>cd", "<cmd>CopilotChatDocs<CR>", desc = "Document Code", mode = { "n", "v" } },
        { "<leader>cg", "<cmd>CopilotChatTests<CR>", desc = "Generate Tests", mode = { "n", "v" } },
    },
    opts = {
        window = {
            layout = "float",
            border = "rounded",
            width = 0.8,
            height = 0.6,
            title = "♟️ Copilot Chat",
        },
        mappings = {
            close = "q",
            submit = "<CR>",
            reset = "<C-r>",
        },
    },
}
