-- lua/plugins/markdown-preview.lua
return {
    "iamcco/markdown-preview.nvim",
    cmd = {"MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle"},
    ft = {"markdown"},
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    keys = {
        { "<leader>mp", "<cmd>MarkdownPreview<CR>", desc = "Start Markdown Preview" },
        { "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", desc = "Stop Markdown Preview" },
        { "<leader>mt", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
    },
    config = function()
        -- Markdown preview configuration
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_command_for_global = 0
        vim.g.mkdp_open_to_the_world = 0
        vim.g.mkdp_browser = ''
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_page_title = '${name} - Markdown Preview'
        
        -- Use a custom theme that matches your Neovim theme
        vim.g.mkdp_theme = 'dark'
        
        -- Set up keymap to open the preview for documentation files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                -- Check if this is a documentation file
                local file_path = vim.fn.expand('%:p')
                if file_path:match("/docs/") then
                    -- Add command to open docs directory in file explorer
                    vim.api.nvim_buf_create_user_command(0, "OpenDocsFolder", function()
                        local project_root = vim.fn.fnamemodify(file_path, ":h:h")
                        local docs_dir = project_root .. "/docs"
                        vim.cmd("!xdg-open " .. docs_dir)
                    end, {})
                    
                    vim.api.nvim_echo({
                        {"Markdown documentation file detected: ", "Normal"}, 
                        {"<leader>mp", "Special"}, 
                        {" to preview, ", "Normal"},
                        {"<leader>md", "Special"}, 
                        {" to open docs folder", "Normal"}
                    }, true, {})
                end
            end
        })
        
        -- Create command to view documentation index
        vim.api.nvim_create_user_command("ViewDocs", function()
            local current_path = vim.fn.expand("%:p:h")
            local path = current_path
            
            -- Find project root
            while path ~= "/" do
                local docs_path = path .. "/docs"
                local index_path = docs_path .. "/index.md"
                
                if vim.fn.isdirectory(docs_path) == 1 and vim.fn.filereadable(index_path) == 1 then
                    vim.cmd("edit " .. index_path)
                    vim.cmd("MarkdownPreview")
                    return
                end
                
                path = vim.fn.fnamemodify(path, ":h")
            end
            
            vim.notify("Documentation index not found", vim.log.levels.ERROR)
        end, {})
        
        -- Add keymapping for viewing docs
        vim.keymap.set("n", "<leader>md", "<cmd>ViewDocs<CR>", { desc = "View Documentation Index" })
    end,
}
