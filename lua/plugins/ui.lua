return {
    -- Improved status line with more information and better looks
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {
            options = {
                theme = "gruvbox",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    { "mode", icon = "" }, -- alternative mode icon
                },
                lualine_b = {
                    { "branch", icon = "" }, -- using a common branch symbol
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        colored = true,
                    },
                },
                lualine_c = {
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
                    {
                        function() return require("nvim-navic").get_location() end,
                        cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        sources = { "nvim_lsp" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " }
                    },
                    { "encoding" },
                    { "fileformat", symbols = { unix = "", dos = "", mac = "" } },
                },
                lualine_y = {
                    { "progress" },
                },
                lualine_z = {
                    { "location" },
                },
            },
            extensions = { "neo-tree", "lazy" },
        },
    },

    -- Buffer line at the top of the editor
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete other buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete buffers to the right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete buffers to the left" },
            { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
            { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
            { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
            { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
        },
        opts = {
            options = {
                mode = "buffers",
                show_buffer_close_icons = true,
                show_close_icon = false,
                always_show_bufferline = true,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diag)
                    local icons = {
                        Error = " ",
                        Warn = " ",
                        Hint = " ",
                        Info = " ",
                    }
                    local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                        .. (diag.warning and icons.Warn .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "  File Explorer", -- using a common folder icon
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },

    -- Colorize color codes in files
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                names = false,
                RRGGBBAA = true,
                css = true,
                css_fn = true,
                mode = "background",
            },
        },
    },

    -- Better folds with treesitter integration
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufReadPost",
        opts = {},
        init = function()
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
        end,
    },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = false },
        },
    },

    -- Navigation breadcrumbs (updated icon set)
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
        end,
        opts = {
            icons = {
                File = "󰈙",
                Module = "",
                Namespace = "",
                Package = "",
                Class = "󰌗",
                Method = "󰆧",
                Property = "󰜢",
                Field = "",
                Constructor = "",
                Enum = "",
                Interface = "",
                Function = "󰊕",
                Variable = "󰀫",
                Constant = "󰏿",
                String = "",
                Number = "",
                Boolean = "",
                Array = "",
                Object = "",
                Key = "󰌋",
                Null = "󰟢",
                EnumMember = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            },
            lsp = {
                auto_attach = true,
            },
        },
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        opts = {
            mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
            hide_cursor = true,
            stop_eof = true,
            respect_scrolloff = false,
            cursor_scrolls_alone = true,
        },
    },
}
