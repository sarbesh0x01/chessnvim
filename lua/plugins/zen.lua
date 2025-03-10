-- Add to lua/plugins/zen.lua
return {
    "folke/zen-mode.nvim",
    dependencies = {
        "folke/twilight.nvim", -- Dims inactive code for even deeper focus
    },
    cmd = "ZenMode",
    keys = {
        { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
    opts = {
        window = {
            backdrop = 0.95,
            width = 0.85,
            height = 0.9,
            options = {
                signcolumn = "no",        -- Disable signcolumn
                number = false,           -- Disable line numbers
                relativenumber = false,   -- Disable relative line numbers
                cursorline = false,       -- Disable cursorline
                cursorcolumn = false,     -- Disable cursorcolumn
                foldcolumn = "0",         -- Disable foldcolumn
                list = false,             -- Disable listchars
            },
        },
        plugins = {
            twilight = { enabled = true }, -- Enable code dimming
            gitsigns = { enabled = false }, -- Disable git signs
            tmux = { enabled = false },     -- Disable tmux statusline
            kitty = {
                enabled = false,
                font = "+2", -- Font size increment
            },
        },
        -- Chess-themed messages
        on_open = function()
            vim.cmd("echo 'Entering deep focus mode... like a chess grandmaster'")
        end,
        on_close = function()
            vim.cmd("echo 'Returning to the board...'")
        end,
    },
}
