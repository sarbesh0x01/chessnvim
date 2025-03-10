-- Add to lua/plugins/session.lua
return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
        { "<leader>sl", "<cmd>SessionRestore<CR>", desc = "Restore session" },
    },
    config = function()
        -- Fix sessionoptions first to include localoptions
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        
        local auto_session = require("auto-session")
        
        -- Setup auto-session with updated configuration options
        auto_session.setup({
            log_level = "info",
            auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
            auto_session_enabled = true,
            auto_session_create_enabled = true,
            auto_save_enabled = true,
            auto_restore_enabled = false,
            auto_session_use_git_branch = true,
            
            auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            
            pre_save_cmds = {
                function() 
                    local path = vim.fn.getcwd()
                    local path_parts = vim.fn.split(path, "/")
                    local project_name = path_parts[#path_parts]
                    local pieces = {"♙", "♘", "♗", "♖", "♕", "♔"}
                    local piece = pieces[math.random(#pieces)]
                    print("Saving session: " .. piece .. "_" .. project_name)
                end
            },
        })
        
        -- Function to calculate session file path like auto-session does
        local function get_session_file_path()
            local cwd = vim.fn.getcwd()
            local cwd_escaped = cwd:gsub("/", "%%")
            return vim.fn.stdpath("data") .. "/sessions/" .. cwd_escaped .. ".vim"
        end
        
        -- Enhanced session restoration with error handling
        local function restore_session(path)
            local session_path = path or get_session_file_path()
            
            local success, err = pcall(function()
                if vim.fn.filereadable(session_path) == 1 then
                    vim.cmd("source " .. vim.fn.fnameescape(session_path))
                    vim.notify("Session restored from: " .. session_path, vim.log.levels.INFO)
                else
                    vim.notify("Session file not found: " .. session_path, vim.log.levels.ERROR)
                end
            end)
            
            if not success then
                vim.notify("Session restoration failed: " .. tostring(err), vim.log.levels.ERROR)
            end
        end
        
        -- Function to find all session files
        local function get_sessions()
            local session_dir = vim.fn.stdpath("data") .. "/sessions/"
            local sessions = {}
            
            -- Create the directory if it doesn't exist
            if vim.fn.isdirectory(session_dir) == 0 then
                vim.fn.mkdir(session_dir, "p")
                vim.notify("Created sessions directory: " .. session_dir, vim.log.levels.INFO)
                return {}
            end
            
            local handle = vim.loop.fs_scandir(session_dir)
            if handle then
                while true do
                    local name, type = vim.loop.fs_scandir_next(handle)
                    if not name then break end
                    if type == "file" and name:match("%.vim$") then
                        local path = session_dir .. name
                        local display_name = name:gsub("%%", "/"):gsub("%.vim$", "")
                        
                        -- Verify the file is readable
                        if vim.fn.filereadable(path) == 1 then
                            table.insert(sessions, {
                                name = display_name,
                                path = path
                            })
                        end
                    end
                end
            end
            return sessions
        end
        
        -- Function to delete a session with UI select
        local function delete_session()
            local sessions = get_sessions()
            if #sessions == 0 then
                vim.notify("No sessions found", vim.log.levels.WARN)
                return
            end
            
            vim.ui.select(sessions, {
                prompt = "Select session to delete:",
                format_item = function(item) return item.name end,
            }, function(choice)
                if choice then
                    local success, err = pcall(vim.fn.delete, choice.path)
                    if success then
                        vim.notify("Deleted session: " .. choice.name, vim.log.levels.INFO)
                    else
                        vim.notify("Failed to delete session: " .. tostring(err), vim.log.levels.ERROR)
                    end
                end
            end)
        end
        
        -- Function to find and load session via Telescope
        local function find_session()
            local sessions = get_sessions()
            if #sessions == 0 then
                vim.notify("No sessions found. Save a session first with <leader>ss", vim.log.levels.WARN)
                return
            end
            
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            
            pickers.new({}, {
                prompt_title = "♟️ Chess Sessions",
                finder = finders.new_table {
                    results = sessions,
                    entry_maker = function(entry)
                        return {
                            value = entry.path,
                            display = entry.name,
                            ordinal = entry.name,
                            path = entry.path,
                        }
                    end,
                },
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        if selection then
                            restore_session(selection.path)
                        end
                    end)
                    return true
                end,
            }):find()
        end
        
        -- Create user commands for the session functions
        vim.api.nvim_create_user_command("SessionFind", find_session, {})
        vim.api.nvim_create_user_command("SessionDelete", delete_session, {})
        
        -- Add keymaps via vim.keymap.set
        vim.keymap.set("n", "<leader>sd", find_session, { desc = "Find session" })
        vim.keymap.set("n", "<leader>sx", delete_session, { desc = "Delete session" })
        
        -- Create diagnostic command - FIXED to not use get_session_file_path
        vim.api.nvim_create_user_command("SessionDebug", function()
            local session_dir = vim.fn.stdpath("data") .. "/sessions/"
            local current_dir = vim.fn.getcwd()
            local current_dir_escaped = current_dir:gsub("/", "%%")
            local expected_session_file = session_dir .. current_dir_escaped .. ".vim"
            
            print("-------- Session Diagnostics --------")
            print("Session directory: " .. session_dir)
            print("Current directory: " .. current_dir)
            print("Expected session file: " .. expected_session_file)
            print("Session options: " .. vim.o.sessionoptions)
            
            if vim.fn.filereadable(expected_session_file) == 1 then
                print("Session file exists and is readable")
                print("Session file size: " .. vim.fn.getfsize(expected_session_file) .. " bytes")
                
                -- Check file permissions
                local stat = vim.loop.fs_stat(expected_session_file)
                if stat then
                    print("File permissions: " .. stat.mode)
                end
                
                -- Check first few lines of the session file
                local file = io.open(expected_session_file, "r")
                if file then
                    print("First 3 lines of session file:")
                    for i = 1, 3 do
                        local line = file:read("*line")
                        if line then print("  " .. line) else break end
                    end
                    file:close()
                end
            else
                print("Session file does not exist or is not readable")
                
                -- Check if directory exists and is writable
                if vim.fn.isdirectory(session_dir) == 1 then
                    print("Session directory exists")
                    local stat = vim.loop.fs_stat(session_dir)
                    if stat then
                        print("Directory permissions: " .. stat.mode)
                    end
                else
                    print("Session directory does not exist!")
                end
            end
            
            -- List all session files
            print("\nAvailable session files:")
            local sessions = get_sessions()
            for _, session in ipairs(sessions) do
                print("  " .. session.name .. " => " .. session.path)
            end
        end, {})
        
        -- Custom restore function that bypasses auto-session
        local function restore_direct(path)
            if not path then
                path = get_session_file_path()
            end
            
            if vim.fn.filereadable(path) == 1 then
                vim.cmd("source " .. vim.fn.fnameescape(path))
                vim.notify("Session restored directly from: " .. path, vim.log.levels.INFO)
            else
                vim.notify("Session file not found: " .. path, vim.log.levels.ERROR)
            end
        end
        
        -- Enhanced restore command - bypassing auto-session
        vim.api.nvim_create_user_command("SessionRestoreVerbose", function()
            restore_direct()
        end, {})
        
        -- Command to restore a specific session by its path
        vim.api.nvim_create_user_command("SessionRestorePath", function(opts)
            if opts.args and opts.args ~= "" then
                restore_direct(opts.args)
            else
                vim.notify("Please provide a session file path", vim.log.levels.ERROR)
            end
        end, { nargs = 1, complete = "file" })
        
        -- Add debug keymap
        vim.keymap.set("n", "<leader>sD", ":SessionDebug<CR>", { desc = "Session debug info" })
        vim.keymap.set("n", "<leader>sR", ":SessionRestoreVerbose<CR>", { desc = "Restore session (verbose)" })
        
        -- Create a test session command for troubleshooting
        vim.api.nvim_create_user_command("SessionCreateTest", function()
            local test_file = vim.fn.stdpath("data") .. "/sessions/test-session.vim"
            vim.cmd("mksession! " .. test_file)
            print("Created test session at: " .. test_file)
            print("To restore manually: nvim -S " .. test_file)
        end, {})
        
        vim.keymap.set("n", "<leader>st", ":SessionCreateTest<CR>", { desc = "Create test session" })
    end,
}
