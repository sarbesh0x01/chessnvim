-- Enhanced theme setup for better visual experience
return {
    -- Gruvbox theme but more refined and polished
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000, -- Load first
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "hard",
                palette_overrides = {},
                overrides = {
                    -- Enhanced UI elements
                    SignColumn = { bg = "NONE" },
                    GruvboxRedSign = { bg = "NONE" },
                    GruvboxGreenSign = { bg = "NONE" },
                    GruvboxYellowSign = { bg = "NONE" },
                    GruvboxBlueSign = { bg = "NONE" },
                    GruvboxPurpleSign = { bg = "NONE" },
                    GruvboxAquaSign = { bg = "NONE" },
                    GruvboxOrangeSign = { bg = "NONE" },

                    -- Improved syntax highlighting
                    Identifier = { fg = "#83a598" },
                    Function = { fg = "#b8bb26", bold = true },
                    Type = { fg = "#fabd2f" },
                    Statement = { fg = "#fb4934" },

                    -- Dashboard elements
                    DashboardHeader = { fg = "#d65d0e", bold = true },
                    DashboardCenter = { fg = "#689d6a" },
                    DashboardShortcut = { fg = "#458588" },
                    DashboardFooter = { fg = "#a89984", italic = true },

                    -- Better diagnostic highlights
                    DiagnosticUnderlineError = { sp = "#fb4934", undercurl = true },
                    DiagnosticUnderlineWarn = { sp = "#fabd2f", undercurl = true },
                    DiagnosticUnderlineInfo = { sp = "#83a598", undercurl = true },
                    DiagnosticUnderlineHint = { sp = "#8ec07c", undercurl = true },
                },
                dim_inactive = false,
                transparent_mode = false,
            })

            -- Apply the colorscheme
            vim.cmd.colorscheme("gruvbox")

            -- Set transparent background if system supports it
            local has_transparent = vim.fn.has("termguicolors") == 1
            if has_transparent then
                -- Customize background
                vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
                vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
                vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })
            end

            -- Enhance terminal colors
            vim.g.terminal_color_0 = "#282828"
            vim.g.terminal_color_1 = "#cc241d"
            vim.g.terminal_color_2 = "#98971a"
            vim.g.terminal_color_3 = "#d79921"
            vim.g.terminal_color_4 = "#458588"
            vim.g.terminal_color_5 = "#b16286"
            vim.g.terminal_color_6 = "#689d6a"
            vim.g.terminal_color_7 = "#a89984"
            vim.g.terminal_color_8 = "#928374"
            vim.g.terminal_color_9 = "#fb4934"
            vim.g.terminal_color_10 = "#b8bb26"
            vim.g.terminal_color_11 = "#fabd2f"
            vim.g.terminal_color_12 = "#83a598"
            vim.g.terminal_color_13 = "#d3869b"
            vim.g.terminal_color_14 = "#8ec07c"
            vim.g.terminal_color_15 = "#ebdbb2"
        end,
    },

    -- Better dashboard with chess theme
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local dashboard = require("alpha.themes.dashboard")

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

            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
                dashboard.button("p", "  Plugins", ":Lazy<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            -- Chess quote footer with version info
            local function footer()
                local chess_quote = {
                    "\"Chess is the gymnasium of the mind.\" — Blaise Pascal",
                    "\"Every chess master was once a beginner.\" — Irving Chernev",
                    "\"Chess is life in miniature.\" — Garry Kasparov",
                    "\"Chess is the struggle against the error.\" — Johannes Zukertort",
                    "\"Chess is beautiful enough to waste your life for.\" — Hans Ree"
                }
                return chess_quote[math.random(#chess_quote)] ..
                "\n\n  " .. " ♟️  ♞  ♝  ♜  ♛  ♚  " .. os.date("%Y-%m-%d")
            end

            dashboard.section.footer.val = footer()

            -- Set header and footer formatting
            dashboard.section.header.opts.hl = "DashboardHeader"
            dashboard.section.buttons.opts.hl = "DashboardCenter"
            dashboard.section.footer.opts.hl = "DashboardFooter"

            -- Options
            dashboard.opts.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }

            return dashboard
        end,
        config = function(_, dashboard)
            -- Close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
}
