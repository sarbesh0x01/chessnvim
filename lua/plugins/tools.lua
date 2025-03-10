-- Enhanced tools for better productivity
return {
    -- Git signs in the gutter
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "󰍵" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "│" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- Navigation
                map("n", "]g", gs.next_hunk, "Next Git hunk")
                map("n", "[g", gs.prev_hunk, "Previous Git hunk")
                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                map("n", "<leader>hd", gs.diffthis, "Diff this")
                map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
            end,
        },
    },

    -- Enhanced Git client (Magit-like interface)
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
            { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit" },
            { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
            { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push" },
            { "<leader>gb", "<cmd>Neogit branch<CR>", desc = "Git branches" },
            { "<leader>gl", "<cmd>Neogit log<CR>", desc = "Git log" },
        },
        opts = {
            kind = "split",
            integrations = {
                diffview = true,
                telescope = true,
            },
            signs = {
                section = { "", "" },
                item = { "", "" },
                hunk = { "", "" },
            },
            disable_context_highlighting = false,
            disable_commit_confirmation = false,
            disable_line_numbers = true,
            status = {
                recent_commit_count = 10,
            },
            popup = {
                kind = "split",
            },
            sections = {
                untracked = {
                    folded = false,
                    hidden = false,
                },
                unstaged = {
                    folded = false,
                    hidden = false,
                },
                staged = {
                    folded = false,
                    hidden = false,
                },
                stashes = {
                    folded = true,
                    hidden = false,
                },
                unpulled = {
                    folded = true,
                    hidden = false,
                },
                unmerged = {
                    folded = false,
                    hidden = false,
                },
                recent = {
                    folded = false,
                    hidden = false,
                },
            },
        },
        -- Just use the default setup without trying to modify the buffer
        config = function(_, opts)
            require("neogit").setup(opts)
        end,
    },

    -- DiffView for better diff visualization
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Repo history" },
            { "<leader>gm", "<cmd>DiffviewOpen origin/main<CR>", desc = "Diff with main" },
        },
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff2_horizontal",
                    winbar_info = true,
                },
                file_history = {
                    layout = "diff2_horizontal",
                    winbar_info = true,
                },
            },
            file_panel = {
                listing_style = "tree",
                tree_options = {
                    flatten_dirs = true,
                    folder_statuses = "only_folded",
                },
            },
            hooks = {
                diff_buf_read = function(bufnr)
                    -- Set options for diff buffers
                    vim.opt_local.wrap = false
                    vim.opt_local.colorcolumn = ""
                end,
            },
        },
    },

    -- Enhanced terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>t", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
            { "<leader>T", "<cmd>ToggleTerm direction=float<cr>",      desc = "Toggle float terminal" },
        },
        opts = {
            size = 15,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        },
    },

    -- Which-key for keybinding help
    -- Update this section in your lua/plugins/tools.lua

    -- Remove or comment out this WhichKey section in your tools.lua file:
    -- Which-key for keybinding help
    
    -- It will be handled by our new which-key-override.lua file

    -- Better search with Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find Files" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",              desc = "Recent Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",             desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",              desc = "Commands" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
            { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",           desc = "Diagnostics" },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "truncate" },
                file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                    },
                },
                mappings = {
                    i = {
                        ["<C-j>"] = function(...)
                            return require("telescope.actions").move_selection_next(...)
                        end,
                        ["<C-k>"] = function(...)
                            return require("telescope.actions").move_selection_previous(...)
                        end,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("fzf")
        end,
    },

    -- Powerful text editing
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },

    -- Better search and replace across files
    {
        "nvim-pack/nvim-spectre",
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
    },

    -- Highlight and navigate through todos
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true,
            keywords = {
                FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
        },
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
        },
    },
}
