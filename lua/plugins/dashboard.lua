-- lua/plugins/dashboard.lua
return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII art for CHESS NVIM
        dashboard.section.header.val = {
            "",
            "   ██████╗██╗  ██╗███████╗███████╗███████╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
            "  ██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝    ████╗  ██║██║   ██║██║████╗ ████║",
            "  ██║     ███████║█████╗  ███████╗███████╗    ██╔██╗ ██║██║   ██║██║██╔████╔██║",
            "  ██║     ██╔══██║██╔══╝  ╚════██║╚════██║    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "  ╚██████╗██║  ██║███████╗███████║███████║    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "   ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "",
            "",
        }

        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
            dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
            dashboard.button("p", "  Plugins", ":Lazy<CR>"),
            dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
        }

        -- Chess piece footer with version info
        local function footer()
            local chess_quote = {
                "\"Chess is the gymnasium of the mind.\" — Blaise Pascal",
                "\"Every chess master was once a beginner.\" — Irving Chernev",
                "\"Chess is life in miniature.\" — Garry Kasparov",
                "\"Chess is the struggle against the error.\" — Johannes Zukertort",
                "\"Chess is beautiful enough to waste your life for.\" — Hans Ree"
            }
            return chess_quote[math.random(#chess_quote)] .. "\n\n   ♟️  ♞  ♝  ♜  ♛  ♚"
        end

        dashboard.section.footer.val = footer()

        -- Set header and footer formatting
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Hide tabline and statusline on startup screen
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            desc = "Disable status and tabline for alpha",
            callback = function()
                vim.opt.laststatus = 0
                vim.opt.showtabline = 0
            end,
        })

        -- Restore tabline and statusline when leaving startup screen
        vim.api.nvim_create_autocmd("BufUnload", {
            buffer = 0,
            desc = "Enable status and tabline after alpha",
            callback = function()
                vim.opt.laststatus = 2
                vim.opt.showtabline = 2
            end,
        })

        -- Set custom highlights for alpha dashboard
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#dfa752" })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#8ec07c" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a89984" })
    end
}
