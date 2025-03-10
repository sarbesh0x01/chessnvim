-- Complete configuration for Copilot
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
        -- Basic Copilot commands
        { "<leader>at", "<cmd>Copilot toggle<CR>", desc = "Toggle Copilot" },
        { "<leader>as", "<cmd>Copilot status<CR>", desc = "Copilot status" },
        { "<leader>ap", "<cmd>Copilot panel<CR>", desc = "Copilot panel" },
        { "<leader>ae", "<cmd>Copilot enable<CR>", desc = "Enable Copilot" },
        { "<leader>ad", "<cmd>Copilot disable<CR>", desc = "Disable Copilot" },
    },
    opts = {
        panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>",
            },
        },
-- In your lua/plugins/ai.lua file, update the suggestion keymap:
suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
        -- Change these keymaps to more reliable options
        accept = "<C-y>",           -- Ctrl+y to accept
        accept_word = "<C-w>",      -- Ctrl+w for word
        accept_line = "<C-l>",      -- Ctrl+l for line
        next = "<C-n>",             -- Ctrl+n for next
        prev = "<C-p>",             -- Ctrl+p for previous
        dismiss = "<C-e>",          -- Ctrl+e to dismiss
    },
},
        filetypes = {
            -- Enable for all filetypes
            ["*"] = true,
            -- Disable for specific filetypes
            ["TelescopePrompt"] = false,
            ["neo-tree"] = false,
            ["help"] = false,
        },
    },
    -- Additional configuration in init function
    init = function()
        -- Set up additional global options
        vim.g.copilot_assume_mapped = true
        -- Add any other init code here
    end,
    config = function(_, opts)
        require("copilot").setup(opts)
        
        -- Post-setup message to guide users
        vim.api.nvim_create_autocmd("User", {
            pattern = "CopilotReady",
            callback = function()
                vim.notify("♟️ Copilot is ready to assist you", vim.log.levels.INFO)
                
                -- Show available keymaps on startup
                vim.notify(
                    "Copilot Keymaps:\n" ..
                    "- Alt+l: Accept suggestion\n" ..
                    "- Alt+w: Accept word\n" ..
                    "- Alt+j: Accept line\n" ..
                    "- Alt+] / Alt+[: Next/previous suggestion\n" ..
                    "- <leader>ap: Open suggestions panel\n" ..
                    "- <leader>at: Toggle Copilot", 
                    vim.log.levels.INFO
                )
            end,
        })
    end,
}
