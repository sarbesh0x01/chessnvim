-- Add to lua/plugins/focus.lua
return {
    -- Centered cursor mode
    "arnamak/stay-centered.nvim",
    config = function()
        local stay_centered = require("stay-centered")
        
        stay_centered.setup({
            -- Options for centered cursor navigation
            skip_filetypes = {
                "neo-tree",
                "help",
                "dashboard",
            },
        })
        
        -- Add chess-themed commands with proper API calls
        vim.api.nvim_create_user_command("ChessFocus", function()
            -- Enable everything for deep focus
            vim.cmd("ZenMode")
            vim.cmd("Twilight")
            -- Use the proper API call instead of a command
            stay_centered.enable()
            vim.notify("♚ Grand Master focus mode activated", vim.log.levels.INFO)
        end, {})
        
        vim.api.nvim_create_user_command("ChessBoard", function()
            -- Disable everything and return to normal
            vim.cmd("ZenMode")
            vim.cmd("TwilightDisable")
            -- Use the proper API call instead of a command
            stay_centered.disable()
            vim.notify("♟ Returned to the full chess board", vim.log.levels.INFO)
        end, {})
        
        -- Add keymaps
        vim.keymap.set("n", "<leader>cf", "<cmd>ChessFocus<CR>", { desc = "Chess Focus Mode" })
        vim.keymap.set("n", "<leader>cb", "<cmd>ChessBoard<CR>", { desc = "Chess Board Mode" })
    end,
}
