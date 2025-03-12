-- C++ Documentation Generator using GitHub Copilot
return {
    "zbirenbaum/copilot.lua", -- Use your existing Copilot setup
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = {
        "CppDocs",
        "CppDocsFile",
    },
    keys = {
        { "<leader>dc", "<cmd>CppDocs<CR>", desc = "C++ Documentation Generator" },
        { "<leader>df", "<cmd>CppDocsFile<CR>", desc = "Document Current File" },
    },
    config = function()
        -- Create the docs namespace
        local CppDocs = {}
        
        -- Configuration with sensible defaults
        CppDocs.config = {
            -- Project directories to scan
            src_dir = "src",
            include_dir = "include",
            
            -- Output directory for documentation
            output_dir = "docs",
            
            -- Default prompts for documentation
            prompts = {
                header = "Generate comprehensive documentation for this C++ header file. Include purpose, classes, functions, relationships with other components, and usage examples.",
                source = "Generate comprehensive documentation for this C++ source file. Explain the implementation, algorithms used, and any important technical details.",
            },
        }
        
        -- Utility function to check if a path exists
        local function path_exists(path)
            return vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1
        end
        
        -- Get project root directory
        local function get_project_root()
            local markers = {".git", "CMakeLists.txt", "Makefile", "package.json"}
            local current_path = vim.fn.expand("%:p:h")
            local path = current_path
            
            while path ~= "/" do
                for _, marker in ipairs(markers) do
                    if path_exists(path .. "/" .. marker) then
                        return path
                    end
                end
                path = vim.fn.fnamemodify(path, ":h")
            end
            
            return current_path
        end
        
        -- Get all C++ files in a directory recursively
        local function get_cpp_files(dir, file_type)
            if not path_exists(dir) then
                vim.notify("Directory doesn't exist: " .. dir, vim.log.levels.ERROR)
                return {}
            end
            
            local extensions = {}
            if file_type == "header" then
                extensions = {".h", ".hpp", ".hxx", ".hh"}
            elseif file_type == "source" then
                extensions = {".c", ".cpp", ".cxx", ".cc"}
            else
                extensions = {".h", ".hpp", ".hxx", ".hh", ".c", ".cpp", ".cxx", ".cc"}
            end
            
            local files = {}
            local handle = vim.loop.fs_scandir(dir)
            
            while handle do
                local name, type = vim.loop.fs_scandir_next(handle)
                if not name then
                    break
                end
                
                local path = dir .. "/" .. name
                
                if type == "directory" then
                    -- Skip hidden directories
                    if name:sub(1, 1) ~= "." then
                        local subdir_files = get_cpp_files(path, file_type)
                        for _, file in ipairs(subdir_files) do
                            table.insert(files, file)
                        end
                    end
                elseif type == "file" then
                    for _, ext in ipairs(extensions) do
                        if name:match(ext .. "$") then
                            table.insert(files, path)
                            break
                        end
                    end
                end
            end
            
            return files
        end
        
        -- Write content to file
        local function write_file(path, content)
            -- Ensure directory exists
            local dir = vim.fn.fnamemodify(path, ":h")
            if vim.fn.isdirectory(dir) == 0 then
                vim.fn.mkdir(dir, "p")
            end
            
            local file = io.open(path, "w")
            if not file then
                vim.notify("Cannot write to file: " .. path, vim.log.levels.ERROR)
                return false
            end
            
            file:write(content)
            file:close()
            return true
        end
        
        -- Generate a unique buffer name with timestamp
        local function get_unique_buffer_name(base_name)
            local timestamp = os.time()
            return base_name .. "_" .. timestamp
        end
        
        -- Function to generate documentation for the current file
        function CppDocs.document_current_file()
            -- Get the current file path
            local file_path = vim.fn.expand('%:p')
            if file_path == "" then
                vim.notify("No file is open", vim.log.levels.ERROR)
                return
            end
            
            -- Determine if this is a header or source file
            local ext = vim.fn.expand('%:e'):lower()
            local is_header = (ext == "h" or ext == "hpp" or ext == "hxx" or ext == "hh")
            local is_source = (ext == "c" or ext == "cpp" or ext == "cxx" or ext == "cc")
            
            if not (is_header or is_source) then
                vim.notify("Not a C/C++ file", vim.log.levels.ERROR)
                return
            end
            
            -- Create output directory if it doesn't exist
            local project_root = get_project_root()
            local output_path = project_root .. "/" .. CppDocs.config.output_dir
            if vim.fn.isdirectory(output_path) == 0 then
                vim.fn.mkdir(output_path, "p")
            end
            
            -- Prepare for documentation
            local file_type = is_header and "header" or "source"
            local prompt = CppDocs.config.prompts[file_type]
            
            -- Create a scratch buffer for documentation with a unique name
            local unique_name = get_unique_buffer_name("CppDocsRequest")
            local doc_bufnr = vim.api.nvim_create_buf(false, true)
            
            -- Set buffer options safely
            vim.api.nvim_buf_set_option(doc_bufnr, "filetype", "markdown")
            
            -- Set buffer name safely after creation - avoid duplicate names
            pcall(function() 
                vim.api.nvim_buf_set_name(doc_bufnr, unique_name)
            end)
            
            -- Get the current buffer content
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            
            -- Set content with original code and request
            local content = {
                "# C++ Documentation Request",
                "",
                "## File: " .. vim.fn.expand('%:t'),
                "",
                "## Documentation Task",
                prompt,
                "",
                "## Source Code",
                "```cpp",
            }
            
            -- Add the file content
            for _, line in ipairs(lines) do
                table.insert(content, line)
            end
            
            -- Close code block and add placeholder for documentation
            table.insert(content, "```")
            table.insert(content, "")
            table.insert(content, "## Generated Documentation")
            table.insert(content, "")
            table.insert(content, "<!-- Paste Copilot's response here, then press <leader>ds to save -->")
            
            -- Set the buffer content
            vim.api.nvim_buf_set_lines(doc_bufnr, 0, -1, false, content)
            
            -- Open the buffer in a new split safely
            local current_win = vim.api.nvim_get_current_win()
            local success, err = pcall(function()
                vim.cmd("vsplit")
                vim.api.nvim_win_set_buf(0, doc_bufnr)
            end)
            
            if not success then
                vim.notify("Error opening documentation buffer: " .. err, vim.log.levels.ERROR)
                -- Try to recover by using current window
                pcall(function()
                    vim.api.nvim_win_set_buf(current_win, doc_bufnr)
                end)
            end
            
            -- Create a temporary function for saving documentation
            _G.save_cpp_documentation = function()
                -- Get the buffer content
                local doc_lines = vim.api.nvim_buf_get_lines(doc_bufnr, 0, -1, false)
                local documentation = {}
                
                -- Extract documentation content
                local content_started = false
                local documentation_started = false
                
                for _, line in ipairs(doc_lines) do
                    if not documentation_started and line == "## Generated Documentation" then
                        documentation_started = true
                        table.insert(documentation, "# " .. vim.fn.expand('%:t') .. " Documentation")
                        table.insert(documentation, "")
                        table.insert(documentation, "Generated on: " .. os.date("%Y-%m-%d %H:%M:%S"))
                        table.insert(documentation, "")
                    elseif documentation_started and line ~= "<!-- Paste Copilot's response here, then press <leader>ds to save -->" then
                        -- Skip the placeholder comment but include everything else
                        if not (line == "" and not content_started) then
                            content_started = true
                            table.insert(documentation, line)
                        end
                    end
                end
                
                -- Check if we have actual documentation content
                if #documentation <= 4 then  -- Only has the header we added
                    vim.notify("No documentation content found. Please add content after the 'Generated Documentation' section.", vim.log.levels.ERROR)
                    return
                end
                
                -- Get relative path for the output file
                local rel_path = file_path:gsub("^" .. project_root .. "/", "")
                local doc_path = project_root .. "/" .. CppDocs.config.output_dir .. "/" .. rel_path .. ".md"
                
                -- Write the documentation to file
                if write_file(doc_path, table.concat(documentation, "\n")) then
                    vim.notify("Documentation saved to: " .. doc_path, vim.log.levels.INFO)
                    
                    -- Update index file
                    local index_path = project_root .. "/" .. CppDocs.config.output_dir .. "/index.md"
                    local index_content = {}
                    
                    -- Read existing index file if it exists
                    local index_file = io.open(index_path, "r")
                    if index_file then
                        local content = index_file:read("*all")
                        index_file:close()
                        
                        -- Check if the file is already in the index
                        if not content:find(rel_path) then
                            -- Add to the appropriate section
                            local new_content = {}
                            local section_found = false
                            
                            for line in content:gmatch("[^\r\n]+") do
                                table.insert(new_content, line)
                                
                                if is_header and line == "## Header Files" then
                                    section_found = "header"
                                elseif is_source and line == "## Source Files" then
                                    section_found = "source"
                                elseif section_found and line == "" then
                                    if section_found == "header" and is_header then
                                        table.insert(new_content, "- [" .. rel_path .. "](./" .. rel_path .. ".md)")
                                        section_found = false
                                    elseif section_found == "source" and is_source then
                                        table.insert(new_content, "- [" .. rel_path .. "](./" .. rel_path .. ".md)")
                                        section_found = false
                                    end
                                end
                            end
                            
                            index_content = new_content
                        else
                            -- File already indexed
                            for line in content:gmatch("[^\r\n]+") do
                                table.insert(index_content, line)
                            end
                        end
                    else
                        -- Create new index file
                        table.insert(index_content, "# Project Documentation")
                        table.insert(index_content, "")
                        
                        if is_header then
                            table.insert(index_content, "## Header Files")
                            table.insert(index_content, "")
                            table.insert(index_content, "- [" .. rel_path .. "](./" .. rel_path .. ".md)")
                            table.insert(index_content, "")
                            table.insert(index_content, "## Source Files")
                            table.insert(index_content, "")
                        else
                            table.insert(index_content, "## Header Files")
                            table.insert(index_content, "")
                            table.insert(index_content, "## Source Files")
                            table.insert(index_content, "")
                            table.insert(index_content, "- [" .. rel_path .. "](./" .. rel_path .. ".md)")
                        end
                    end
                    
                    write_file(index_path, table.concat(index_content, "\n"))
                    
                    -- Close the documentation buffer safely
                    pcall(function() vim.api.nvim_buf_delete(doc_bufnr, { force = true }) end)
                    
                    -- Give instructions for the next step
                    vim.notify("Added to documentation index. Use :CppDocs to document more files.", vim.log.levels.INFO)
                end
            end
            
            -- Setup keymapping for saving
            pcall(function()
                vim.api.nvim_buf_set_keymap(doc_bufnr, "n", "<leader>ds", ":lua _G.save_cpp_documentation()<CR>", 
                    { noremap = true, silent = true })
            end)
            
            -- Provide instructions
            vim.api.nvim_echo({
                {"C++ DOCUMENTATION WORKFLOW", "Title"}, 
                {"\n\n", ""},
                {"1. ", "WarningMsg"}, {"Copy the entire buffer content\n", "Normal"},
                {"2. ", "WarningMsg"}, {"Paste it into Copilot or a chat interface\n", "Normal"},
                {"3. ", "WarningMsg"}, {"Copy Copilot's response\n", "Normal"},
                {"4. ", "WarningMsg"}, {"Paste it after the '## Generated Documentation' line\n", "Normal"},
                {"5. ", "WarningMsg"}, {"Press ", "Normal"}, {"<leader>ds", "Statement"}, {" to save the documentation\n", "Normal"},
            }, true, {})
            
            return doc_bufnr
        end
        
        -- Function to document a selected file
        function CppDocs.select_file()
            local project_root = get_project_root()
            
            -- Check if src and include directories exist
            local src_path = project_root .. "/" .. CppDocs.config.src_dir
            local include_path = project_root .. "/" .. CppDocs.config.include_dir
            
            local src_exists = path_exists(src_path)
            local include_exists = path_exists(include_path)
            
            if not (src_exists or include_exists) then
                vim.notify("Neither src nor include directories found. Using current directory.", vim.log.levels.WARN)
                src_path = project_root
                include_path = project_root
            end
            
            -- Get all C++ files
            local files = {}
            
            if include_exists then
                local header_files = get_cpp_files(include_path, "header")
                for _, file in ipairs(header_files) do
                    table.insert(files, { path = file, type = "header" })
                end
            end
            
            if src_exists then
                local source_files = get_cpp_files(src_path, "source")
                for _, file in ipairs(source_files) do
                    table.insert(files, { path = file, type = "source" })
                end
            end
            
            -- If no files found, scan the current directory
            if #files == 0 then
                local current_dir_files = get_cpp_files(project_root, "all")
                for _, file in ipairs(current_dir_files) do
                    local ext = vim.fn.fnamemodify(file, ":e"):lower()
                    local is_header = (ext == "h" or ext == "hpp" or ext == "hxx" or ext == "hh")
                    local file_type = is_header and "header" or "source"
                    table.insert(files, { path = file, type = file_type })
                end
            end
            
            if #files == 0 then
                vim.notify("No C++ files found in the project", vim.log.levels.ERROR)
                return
            end
            
            -- Display selection menu
            vim.ui.select(files, {
                prompt = "Select file to document:",
                format_item = function(item)
                    local rel_path = item.path:gsub("^" .. project_root .. "/", "")
                    return rel_path .. " (" .. item.type .. ")"
                end
            }, function(choice)
                if not choice then
                    return
                end
                
                -- Try to open the file safely
                local success = pcall(function()
                    vim.cmd("edit " .. vim.fn.fnameescape(choice.path))
                end)
                
                if success then
                    -- Document the file now that it's open
                    CppDocs.document_current_file()
                else
                    vim.notify("Failed to open file: " .. choice.path, vim.log.levels.ERROR)
                end
            end)
        end
        
        -- Create user commands
        vim.api.nvim_create_user_command("CppDocs", function()
            CppDocs.select_file()
        end, {})
        
        vim.api.nvim_create_user_command("CppDocsFile", function()
            CppDocs.document_current_file()
        end, {})
        
        -- Log initialization
        vim.notify("C++ Documentation Generator loaded. Use :CppDocs to start.", vim.log.levels.INFO)
    end,
}
