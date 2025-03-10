-- Neo-tree plugin specification
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>e",  "<cmd>Neotree toggle<CR>",     desc = "Toggle Explorer" },
        { "<leader>o",  "<cmd>Neotree focus<CR>",      desc = "Focus Explorer" },
        { "<leader>bf", "<cmd>Neotree buffers<CR>",    desc = "Buffer Explorer" },
        { "<leader>gs", "<cmd>Neotree git_status<CR>", desc = "Git Status" },
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            popup_border_style = "single",
            enable_git_status = true,
            enable_diagnostics = true,

            sources = {
                "filesystem",
                "buffers",
                "git_status",
            },

            source_selector = {
                winbar = true,
                content_layout = "center",
                tabs_layout = "equal",
                separator = "▏", -- More visible separator
                show_separator_on_edge = true,
                sources = {
                    { source = "filesystem", display_name = " Files " },
                    { source = "buffers",    display_name = " Buffers " },
                    { source = "git_status", display_name = " Git " },
                },
                highlight_tab = "NeoTreeTabInactive",
                highlight_tab_active = "NeoTreeTabActive",
                highlight_background = "NeoTreeTabInactive",
                highlight_separator = "NeoTreeTabSeparator",
                highlight_separator_active = "NeoTreeTabSeparator",
            },

            window = {
                position = "left",
                width = 30,
                mappings = {
                    ["<space>"] = "none",
                    ["<cr>"] = "open",
                    ["o"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["H"] = "toggle_hidden",
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["A"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["c"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["y"] = "copy_to_clipboard",
                    ["m"] = "move",
                    ["q"] = "close_window",
                    ["R"] = "refresh",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                },
            },

            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        ".git",
                        "node_modules",
                    },
                    always_show = {
                        ".gitignore",
                        ".env",
                        "CMakeLists.txt",
                        "Makefile",
                    },
                    never_show = {
                        ".DS_Store",
                        "thumbs.db",
                    },
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                group_empty_dirs = false, -- Show empty dirs separately
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watcher = true,
                window = {
                    mappings = {
                        ["/"] = "fuzzy_finder",
                        ["f"] = "filter_on_submit",
                        ["<C-c>"] = "clear_filter",
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["[g"] = "prev_git_modified",
                        ["]g"] = "next_git_modified",
                    },
                },
            },

            buffers = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                show_unloaded = true,
                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["bd"] = "buffer_delete",
                    },
                },
            },

            git_status = {
                window = {
                    mappings = {
                        ["g"] = "git_add_file",
                        ["gu"] = "git_unstage_file",
                        ["gr"] = "git_revert_file",
                        ["gc"] = "git_commit",
                        ["gp"] = "git_push",
                        ["gg"] = "git_commit_and_push",
                    },
                },
            },

            default_component_configs = {
                container = {
                    enable_character_fade = true,
                },
                indent = {
                    indent_size = 2,
                    padding = 1,
                    with_markers = true,
                    indent_marker = "│", -- Vertical line for indentation
                    last_indent_marker = "└", -- Corner for last item in group
                    highlight = "NeoTreeIndentMarker",
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed = "",     -- Explicit folder closed icon
                    folder_open = "",       -- Explicit folder open icon
                    folder_empty = "",      -- Empty folder icon
                    folder_empty_open = "", -- Empty folder open icon
                    default = "",           -- Default file icon
                    highlight = "NeoTreeFileIcon",
                },
                modified = {
                    symbol = "●", -- Clearer modified symbol
                    highlight = "NeoTreeModified",
                },
                name = {
                    trailing_slash = false,
                    highlight_opened_files = true,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
                git_status = {
                    symbols = {
                        -- Change symbols to more visible ones
                        added = "✚", -- Added
                        modified = "", -- Modified
                        deleted = "✖", -- Deleted
                        renamed = "", -- Renamed
                        untracked = "", -- Untracked
                        ignored = "", -- Ignored
                        unstaged = "", -- Unstaged
                        staged = "", -- Staged
                        conflict = "", -- Conflict
                    },
                    align = "right",
                },
                diagnostics = {
                    symbols = {
                        error = " ",
                        warn = " ",
                        info = " ",
                        hint = " ",
                    },
                    highlights = {
                        error = "DiagnosticSignError",
                        warn = "DiagnosticSignWarn",
                        info = "DiagnosticSignInfo",
                        hint = "DiagnosticSignHint",
                    },
                    severity = vim.diagnostic.severity.ERROR, -- Show the highest severity only
                    highlight_diagnostic_line = false,
                },
                symlink_target = {
                    enabled = true,
                },
            },

            renderers = {
                directory = {
                    { "indent" },
                    { "icon" },
                    { "current_filter" },
                    {
                        "container",
                        content = {
                            { "name",           zindex = 10 },
                            { "symlink_target", zindex = 10,         highlight = "NeoTreeSymlink" },
                            { "clipboard",      zindex = 10 },
                            { "diagnostics",    errors_only = false, zindex = 20,                 align = "right",          hide_when_expanded = true },
                            { "git_status",     zindex = 10,         align = "right",             hide_when_expanded = true },
                        },
                    },
                },
                file = {
                    { "indent" },
                    { "icon" },
                    {
                        "container",
                        content = {
                            { "name",           zindex = 10 },
                            { "symlink_target", zindex = 10,         highlight = "NeoTreeSymlink" },
                            { "clipboard",      zindex = 10 },
                            { "bufnr",          zindex = 10 },
                            { "modified",       zindex = 20,         align = "right" },
                            { "diagnostics",    errors_only = false, zindex = 20,                 align = "right" },
                            { "git_status",     zindex = 10,         align = "right" },
                        },
                    },
                },
            },

            commands = {},

            event_handlers = {
                {
                    event = "file_opened",
                    handler = function()
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.signcolumn = "auto"
                    end,
                },
            },
        })

        -- Apply highlights
        vim.cmd([[
          highlight NeoTreeTabActive guifg=#e2c08d gui=bold
          highlight NeoTreeTabInactive guifg=#5c6370
          highlight NeoTreeTabSeparator guifg=#3e4452
          highlight NeoTreeIndentMarker guifg=#3e4452
          highlight NeoTreeExpander guifg=#5c6370
          highlight NeoTreeFileName guifg=#abb2bf
          highlight NeoTreeDirectoryName guifg=#e2c08d gui=bold
          highlight NeoTreeDirectoryIcon guifg=#e2c08d
          highlight NeoTreeSymlink guifg=#c678dd
          highlight NeoTreeRootName guifg=#e2c08d gui=bold
          highlight NeoTreeFileIcon guifg=#abb2bf
          highlight NeoTreeModified guifg=#e06c75
          highlight NeoTreeGitAdded guifg=#98c379
          highlight NeoTreeGitModified guifg=#e2c08d
          highlight NeoTreeGitDeleted guifg=#e06c75
          highlight NeoTreeGitRenamed guifg=#c678dd
          highlight NeoTreeGitConflict guifg=#e06c75 gui=bold
          highlight NeoTreeGitUntracked guifg=#d19a66
        ]])
    end,
}
