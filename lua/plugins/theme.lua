-- lua/plugins/themes.lua
return {
    -- Gruvbox Theme
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000, -- Load themes early
        config = function()
            require("gruvbox").setup({
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
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
                overrides = {
                    -- Enhanced highlighting for chess theme
                    SignColumn = { bg = "NONE" },
                    GruvboxRedSign = { bg = "NONE" },
                    GruvboxGreenSign = { bg = "NONE" },
                    GruvboxYellowSign = { bg = "NONE" },
                    GruvboxBlueSign = { bg = "NONE" },
                    GruvboxPurpleSign = { bg = "NONE" },
                    GruvboxAquaSign = { bg = "NONE" },
                    GruvboxOrangeSign = { bg = "NONE" },
                },
            })
        end
    },
    
    -- Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = { 
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false,
                term_colors = true,
                dim_inactive = {
                    enabled = false,
                    percentage = 0.15,
                },
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    neotree = true,
                    treesitter = true,
                },
                color_overrides = {},
                custom_highlights = {},
            })
        end
    },
    
    -- Kanagawa Theme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true},
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "dragon", -- wave, dragon, lotus
                background = {
                    dark = "dragon",
                    light = "lotus"
                },
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    }
                },
                overrides = function(colors)
                    return {
                        -- Chess-themed tweaks
                        DashboardHeader = { fg = colors.dragonRed, bold = true },
                        DashboardCenter = { fg = colors.dragonGreen },
                        DashboardShortcut = { fg = colors.dragonBlue },
                        DashboardFooter = { fg = colors.dragonGray, italic = true },
                    }
                end,
            })
        end
    },
    
    -- Theme Switcher (no package, just configuration)
    {
        "nvim-lua/plenary.nvim", -- Dependency for the theme switcher
        lazy = false,
        config = function()
            -- Available themes
            local themes = {
                gruvbox = "Gruvbox",
                catppuccin = "Catppuccin",
                catppuccin_latte = "Catppuccin-Latte",
                catppuccin_frappe = "Catppuccin-Frappe", 
                catppuccin_macchiato = "Catppuccin-Macchiato",
                catppuccin_mocha = "Catppuccin-Mocha",
                kanagawa = "Kanagawa",
                kanagawa_wave = "Kanagawa-Wave",
                kanagawa_dragon = "Kanagawa-Dragon",
                kanagawa_lotus = "Kanagawa-Lotus",
            }
            
            -- Create command to switch themes
            vim.api.nvim_create_user_command("ChessTheme", function(opts)
                local theme = opts.args
                
                if theme == "gruvbox" then
                    vim.cmd("colorscheme gruvbox")
                elseif theme == "catppuccin" or theme == "catppuccin_mocha" then
                    vim.g.catppuccin_flavour = "mocha"
                    vim.cmd("colorscheme catppuccin")
                elseif theme == "catppuccin_latte" then
                    vim.g.catppuccin_flavour = "latte"
                    vim.cmd("colorscheme catppuccin")
                elseif theme == "catppuccin_frappe" then
                    vim.g.catppuccin_flavour = "frappe"
                    vim.cmd("colorscheme catppuccin")
                elseif theme == "catppuccin_macchiato" then
                    vim.g.catppuccin_flavour = "macchiato"
                    vim.cmd("colorscheme catppuccin")
                elseif theme == "kanagawa" or theme == "kanagawa_dragon" then
                    vim.g.kanagawa_theme = "dragon"
                    vim.cmd("colorscheme kanagawa")
                elseif theme == "kanagawa_wave" then
                    vim.g.kanagawa_theme = "wave"
                    vim.cmd("colorscheme kanagawa")
                elseif theme == "kanagawa_lotus" then
                    vim.g.kanagawa_theme = "lotus"
                    vim.cmd("colorscheme kanagawa")
                else
                    vim.notify("Unknown theme: " .. theme, vim.log.levels.ERROR)
                    return
                end
                
                -- Save the current theme
                vim.g.chess_current_theme = theme
                vim.notify("Chess theme switched to " .. themes[theme], vim.log.levels.INFO)
            end, {
                nargs = 1,
                complete = function()
                    return {
                        "gruvbox",
                        "catppuccin", "catppuccin_latte", "catppuccin_frappe", 
                        "catppuccin_macchiato", "catppuccin_mocha",
                        "kanagawa", "kanagawa_wave", "kanagawa_dragon", "kanagawa_lotus"
                    }
                end
            })
            
            -- Create command to cycle through themes
            vim.api.nvim_create_user_command("ChessThemeNext", function()
                local theme_order = {
                    "gruvbox",
                    "catppuccin_mocha",
                    "kanagawa_dragon",
                }
                
                local current_theme = vim.g.chess_current_theme or "gruvbox"
                local current_index = 1
                
                for i, theme in ipairs(theme_order) do
                    if theme == current_theme then
                        current_index = i
                        break
                    end
                end
                
                local next_index = (current_index % #theme_order) + 1
                local next_theme = theme_order[next_index]
                
                vim.cmd("ChessTheme " .. next_theme)
            end, {})
            
            -- Create command to list available themes
            vim.api.nvim_create_user_command("ChessThemeList", function()
                local theme_list = ""
                for k, v in pairs(themes) do
                    theme_list = theme_list .. "- " .. k .. ": " .. v .. "\n"
                end
                
                vim.notify("Available themes:\n" .. theme_list, vim.log.levels.INFO)
            end, {})
            
            -- Set keymaps
            vim.keymap.set("n", "<leader>tc", ":ChessTheme ", { desc = "Change theme" })
            vim.keymap.set("n", "<leader>tn", ":ChessThemeNext<CR>", { desc = "Next theme" })
            vim.keymap.set("n", "<leader>tl", ":ChessThemeList<CR>", { desc = "List themes" })
            
            -- Apply default theme if none is set
            if vim.g.chess_current_theme == nil then
                vim.cmd("colorscheme gruvbox")
                vim.g.chess_current_theme = "gruvbox"
            end
        end,
    },
}
