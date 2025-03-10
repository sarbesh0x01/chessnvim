-- Add to lua/plugins/focus.lua
return {
    -- Centered cursor mode - keeps cursor in the middle like focus on center of board
    "arnamak/stay-centered.nvim",
    config = function()
        require("stay-centered").setup({
            -- Options for centered cursor navigation
            skip_filetypes = {
                "neo-tree",
                "help",
                "dashboard",
            },
        })
        
        -- Add chess-themed commands
        vim.api.nvim_create_user_command("ChessFocus", function()
            -- Enable everything for deep focus
            vim.cmd("ZenMode")
            vim.cmd("Twilight")
            vim.cmd("StayCentered")
            vim.notify("♚ Grand Master focus mode activated", vim.log.levels.INFO)
        end, {})
        
        vim.api.nvim_create_user_command("ChessBoard", function()
            -- Disable everything and return to normal
            vim.cmd("ZenMode")
            vim.cmd("TwilightDisable")
            vim.cmd("StayCenteredDisable")
            vim.notify("♟ Returned to the full chess board", vim.log.levels.INFO)
        end, {})
        
        -- Add keymaps
        vim.keymap.set("n", "<leader>cf", "<cmd>ChessFocus<CR>", { desc = "Chess Focus Mode" })
        vim.keymap.set("n", "<leader>cb", "<cmd>ChessBoard<CR>", { desc = "Chess Board Mode" })
    end,
}
