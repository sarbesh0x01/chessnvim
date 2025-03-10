-- Add this to lua/config/keymap_help.lua

-- Function to show keymaps in a buffer
local function show_keymaps()
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Set a unique buffer name with timestamp to avoid collision
    local timestamp = os.time()
    vim.api.nvim_buf_set_name(buf, "ChessNVIM Keymaps (" .. timestamp .. ")")
    
    -- Set buffer options
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    
    -- Collect keymaps
    local lines = {"# ChessNVIM Keymap Reference", ""}
    local mode_names = {
        n = "Normal Mode",
        i = "Insert Mode",
        v = "Visual Mode",
        x = "Visual Block Mode",
        t = "Terminal Mode"
    }
    
    for mode, mode_name in pairs(mode_names) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        local section_added = false
        local mode_lines = {}
        
        for _, keymap in ipairs(keymaps) do
            if keymap.desc and keymap.desc ~= "" then
                if not section_added then
                    table.insert(mode_lines, "## " .. mode_name)
                    table.insert(mode_lines, "")
                    section_added = true
                end
                table.insert(mode_lines, "- `" .. keymap.lhs .. "` → " .. keymap.desc)
            end
        end
        
        if section_added then
            for _, line in ipairs(mode_lines) do
                table.insert(lines, line)
            end
            table.insert(lines, "")
        end
    end
    
    -- Add the keymaps to the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    -- Make buffer readonly
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.api.nvim_set_option_value("readonly", true, { buf = buf })
    
    -- Set buffer filetype to markdown for nice highlighting
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
    
    -- Open the buffer in a new window
    vim.api.nvim_command("split")
    vim.api.nvim_win_set_buf(0, buf)
    
    -- Set local keymaps for the help buffer
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
    
    -- Print message
    vim.api.nvim_echo({{"Press 'q' to close the keymap reference.", "Normal"}}, false, {})
end

-- Create the command
vim.api.nvim_create_user_command("KeymapHelp", show_keymaps, {})

-- Create the keymap
vim.api.nvim_set_keymap('n', '<leader>?', ':KeymapHelp<CR>', { noremap = true, silent = true, desc = "Show keymap help" })
