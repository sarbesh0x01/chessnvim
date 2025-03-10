-- Add to lua/plugins/terminal-advanced.lua
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        -- More specific terminal commands
        { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Floating terminal" },
        { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
        { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
        { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
        -- Numbered terminals (can have multiple)
        { "<leader>t1", "<cmd>1ToggleTerm<CR>", desc = "Terminal 1" },
        { "<leader>t2", "<cmd>2ToggleTerm<CR>", desc = "Terminal 2" },
        { "<leader>t3", "<cmd>3ToggleTerm<CR>", desc = "Terminal 3" },
        -- Special terminal for lazygit
        { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "LazyGit" },
    },
    opts = {
        -- Your existing toggleterm config
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        
        -- Add lazygit terminal
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "curved",
            },
            hidden = true,
            on_open = function(_)
                vim.cmd("startinsert!")
            end,
        })
        
        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end
    end,
}
