-- Alternative lua/plugins/focus.lua without stay-centered dependency
return {
    "folke/zen-mode.nvim",
    dependencies = {
        "folke/twilight.nvim", -- Dims inactive code
    },
    cmd = "ZenMode",
    keys = {
        { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
        { "<leader>tw", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 0.95,
                width = 0.85,
                height = 0.9,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                    list = false,
                },
            },
            plugins = {
                twilight = { enabled = true },
                gitsigns = { enabled = false },
                tmux = { enabled = false },
            },
            on_open = function()
                vim.cmd("echo 'Entering deep focus mode... like a chess grandmaster'")
                -- Enable scrolloff to keep cursor centered
                vim.opt.scrolloff = 999
            end,
            on_close = function()
                vim.cmd("echo 'Returning to the board...'")
                -- Reset scrolloff to normal
                vim.opt.scrolloff = 8
            end,
        })
        
        -- Add chess-themed commands
        vim.api.nvim_create_user_command("ChessFocus", function()
            -- Enable everything for deep focus
            vim.cmd("ZenMode")
            vim.cmd("Twilight")
            vim.opt.scrolloff = 999 -- Keep cursor centered
            vim.notify("♚ Grand Master focus mode activated", vim.log.levels.INFO)
        end, {})
        
        vim.api.nvim_create_user_command("ChessBoard", function()
            -- Disable everything and return to normal
            vim.cmd("ZenMode")
            vim.cmd("TwilightDisable")
            vim.opt.scrolloff = 8 -- Reset to normal scrolloff
            vim.notify("♟ Returned to the full chess board", vim.log.levels.INFO)
        end, {})
        
        -- Add keymaps
        vim.keymap.set("n", "<leader>cf", "<cmd>ChessFocus<CR>", { desc = "Chess Focus Mode" })
        vim.keymap.set("n", "<leader>cb", "<cmd>ChessBoard<CR>", { desc = "Chess Board Mode" })
    end,
}
