-- Add to lua/plugins/outline.lua
return {
    "hedyhli/outline.nvim",
    keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
        outline_window = {
            width = 25,
            relative_width = false,
            auto_close = true,
            auto_jump = false,
            jump_highlight_duration = 300,
            center_on_jump = true,
            show_numbers = true,
            show_relative_numbers = false,
            wrap = false,
            show_cursorline = true,
            hide_cursor = true,
            focus_on_open = true,
            win_separator = true,
            win_options = {
                wrap = false,
            },
        },
        outline_items = {
            show_symbol_details = true,
            show_symbol_lineno = true,
            highlight_hovered_item = true,
            auto_set_cursor = true,
            -- Add chess piece indicators for different symbol kinds
            symbol_folding = {
                markers = {
                    expanded = "♚",
                    collapsed = "♔",
                },
            },
        },
        symbols = {
            -- Apply chess pieces to different symbol kinds
            icon_override = {
                File = "♜", -- Rook
                Module = "♝", -- Bishop
                Namespace = "♛", -- Queen
                Package = "♞", -- Knight
                Class = "♚", -- King
                Method = "♟", -- Pawn
                Function = "♙", -- Pawn
                Variable = "♖", -- Rook
                Constant = "♗", -- Bishop
                Interface = "♕", -- Queen
                Enum = "♘", -- Knight
                Struct = "♔", -- King
            },
        },
    },
}
