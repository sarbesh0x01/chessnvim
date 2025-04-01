-- Go development support (plugins and configuration)
return {
    -- Go-specific plugins
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        event = {"CmdlineEnter"},
        ft = {"go", "gomod"},
        build = ':lua require("go.install").update_all_sync()', -- Install/update binaries
        config = function()
            require("go").setup({
                -- Gopls configuration
                lsp_cfg = false, -- handled by lspconfig
                lsp_gofumpt = true, -- true: set gofumpt in gopls
                lsp_on_attach = nil, -- use on_attach from lspconfig
                -- Don't auto-format on save (let conform.nvim handle it)
                lsp_codelens = true,
                lsp_keymaps = false, -- use keymaps from lspconfig
                -- Diagnostic
                diagnostic = {
                    underline = true,
                    virtual_text = { space = 0, prefix = "●" },
                    update_in_insert = false,
                },
                -- Runtime configuration
                dap_debug = true,
                dap_debug_gui = true,
                -- Test configuration
                test_runner = 'go', -- richgo, go test, richgo, dlv, ginkgo
                run_in_floaterm = true,
                -- Verbose test output
                verbose_tests = true,
                trouble = true,
                -- Linters/Formatters (many handled by conform.nvim)
                linters = {'revive', 'staticcheck'},
            })
            
            -- Go-specific keymaps
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                callback = function()
                    -- Go debugging
                    vim.keymap.set("n", "<leader>dgt", "<cmd>lua require('dap-go').debug_test()<CR>", { desc = "Debug go test" })
                    -- Go commands
                    vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", { desc = "Go Run" })
                    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Go Test" })
                    vim.keymap.set("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", { desc = "Go Test Function" })
                    vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", { desc = "Go Coverage" })
                    -- Code actions
                    vim.keymap.set("n", "<leader>ga", "<cmd>GoCodeAction<CR>", { desc = "Go Code Action" })
                    vim.keymap.set("n", "<leader>gie", "<cmd>GoIfErr<CR>", { desc = "Go If Err" })
                    vim.keymap.set("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", { desc = "Go Fill Struct" })
                    vim.keymap.set("n", "<leader>gat", "<cmd>GoAddTag<CR>", { desc = "Go Add Tags" })
                    vim.keymap.set("n", "<leader>grt", "<cmd>GoRmTag<CR>", { desc = "Go Remove Tags" })
                    -- Alternative implement
                    vim.keymap.set("n", "<leader>gim", "<cmd>GoImpl<CR>", { desc = "Go Implement" })
                end
            })
            
            -- Add to WhichKey if available
            pcall(function()
                local wk = require("which-key")
                wk.register({
                    ["<leader>g"] = { name = "♟️ Go", _ = "which_key_ignore" },
                    ["<leader>gr"] = { "<cmd>GoRun<CR>", "Go Run" },
                    ["<leader>gt"] = { "<cmd>GoTest<CR>", "Go Test" },
                    ["<leader>gtf"] = { "<cmd>GoTestFunc<CR>", "Go Test Function" },
                    ["<leader>gc"] = { "<cmd>GoCoverage<CR>", "Go Coverage" },
                    ["<leader>ga"] = { "<cmd>GoCodeAction<CR>", "Go Code Action" },
                    ["<leader>gie"] = { "<cmd>GoIfErr<CR>", "Go If Err" },
                    ["<leader>gfs"] = { "<cmd>GoFillStruct<CR>", "Go Fill Struct" },
                    ["<leader>gat"] = { "<cmd>GoAddTag<CR>", "Go Add Tags" },
                    ["<leader>grt"] = { "<cmd>GoRmTag<CR>", "Go Remove Tags" },
                    ["<leader>gim"] = { "<cmd>GoImpl<CR>", "Go Implement" },
                })
            end)
            
            -- Create Go project initialization command
            vim.api.nvim_create_user_command("GoInitMod", function(opts)
                local module_name = opts.args
                if module_name == "" then
                    -- Ask for module name if not provided
                    module_name = vim.fn.input("Module name (e.g. github.com/username/project): ")
                    if module_name == "" then
                        vim.notify("Module name is required", vim.log.levels.ERROR)
                        return
                    end
                end
                
                -- Initialize Go module
                local cmd = "go mod init " .. module_name
                vim.fn.system(cmd)
                vim.notify("Initialized Go module: " .. module_name, vim.log.levels.INFO)
                
                -- Create basic directory structure
                local dirs = {"cmd", "internal", "pkg", "api", "docs", "test"}
                for _, dir in ipairs(dirs) do
                    vim.fn.mkdir(dir, "p")
                end
                
                -- Create main.go in cmd directory
                local main_file = "cmd/main.go"
                local main_content = [[package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, Go!")
}
]]
                vim.fn.writefile(vim.split(main_content, "\n"), main_file)
                
                -- Create README.md
                local readme_content = "# " .. vim.fn.fnamemodify(module_name, ":t") .. "\n\nA Go project.\n"
                vim.fn.writefile(vim.split(readme_content, "\n"), "README.md")
                
                -- Create .gitignore
                local gitignore_content = [[# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Dependency directories (remove the comment below to include it)
# vendor/

# Go workspace file
go.work
]]
                vim.fn.writefile(vim.split(gitignore_content, "\n"), ".gitignore")
                
                -- Open main.go
                vim.cmd("edit " .. main_file)
                
                vim.notify("Go project structure created", vim.log.levels.INFO)
            end, {nargs = "?", desc = "Initialize a new Go module and project structure"})
            
            -- Create a command to add dependencies
            vim.api.nvim_create_user_command("GoGet", function(opts)
                local package = opts.args
                if package == "" then
                    package = vim.fn.input("Package to install: ")
                    if package == "" then
                        vim.notify("Package name is required", vim.log.levels.ERROR)
                        return
                    end
                end
                
                -- Install the package
                local cmd = "go get " .. package
                vim.fn.jobstart(cmd, {
                    on_exit = function(_, code)
                        if code == 0 then
                            vim.notify("Installed: " .. package, vim.log.levels.INFO)
                        else
                            vim.notify("Failed to install: " .. package, vim.log.levels.ERROR)
                        end
                    end,
                })
            end, {nargs = "?", desc = "Install Go package"})
            
            -- Add to WhichKey if available for these commands
            pcall(function()
                local wk = require("which-key")
                wk.register({
                    ["<leader>gi"] = { "<cmd>GoInitMod<CR>", "Initialize Go Module" },
                    ["<leader>gg"] = { "<cmd>GoGet<CR>", "Install Go Package" },
                })
            end)
            
            -- Automatically update imports on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    -- Safer approach for organizing imports
                    local params = vim.lsp.util.make_range_params()
                    params.context = {only = {"source.organizeImports"}}
                    
                    -- Use pcall to handle potential errors
                    local ok, result = pcall(function()
                        return vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                    end)
                    
                    if ok and result then
                        for _, res in pairs(result or {}) do
                            for _, r in pairs(res.result or {}) do
                                if r.edit then
                                    -- Try to apply edits with error handling
                                    pcall(vim.lsp.util.apply_workspace_edit, r.edit)
                                elseif r.command then
                                    -- Try to execute command with error handling
                                    pcall(vim.lsp.buf.execute_command, r.command)
                                end
                            end
                        end
                    end
                end,
            })
            
            -- Create Go snippets
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            local f = ls.function_node
            local c = ls.choice_node
            local fmt = require("luasnip.extras.fmt").fmt
            
            -- Add basic Go snippets
            ls.add_snippets("go", {
                -- Main package and function
                s("main", fmt([[
                package main

                import (
                    {}
                )

                func main() {{
                    {}
                }}
                ]], {
                    i(1, "fmt"),
                    i(2, 'fmt.Println("Hello, World!")'),
                })),
                
                -- Function with error return
                s("fe", fmt([[
                func {}({}) ({}, error) {{
                    {}
                    return {}, nil
                }}
                ]], {
                    i(1, "myFunc"),
                    i(2, "param string"),
                    i(3, "string"),
                    i(4, "// Implementation"),
                    i(5, "result"),
                })),
                
                -- If error check
                s("iferr", fmt([[
                if err != nil {{
                    return {}
                }}
                {}
                ]], {
                    c(1, {
                        t("err"),
                        t("fmt.Errorf(\"failed to %s: %w\", \"action\", err)"),
                        t("nil, err"),
                        i(nil, ""),
                    }),
                    i(2, ""),
                })),
                
                -- Struct declaration
                s("st", fmt([[
                type {} struct {{
                    {}
                }}
                ]], {
                    i(1, "MyStruct"),
                    i(2, "// Fields"),
                })),
                
                -- Interface declaration
                s("iface", fmt([[
                type {} interface {{
                    {}
                }}
                ]], {
                    i(1, "MyInterface"),
                    i(2, "// Methods"),
                })),
                
                -- Test function
                s("test", fmt([[
                func Test{}(t *testing.T) {{
                    {}
                }}
                ]], {
                    i(1, "Function"),
                    i(2, "// Test logic"),
                })),
            })
            
            vim.notify("♟️ Go configuration loaded!", vim.log.levels.INFO)
        end
    },
    
    -- Go debugging support
    {
        "leoluz/nvim-dap-go",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            require("dap-go").setup({
                -- Delve configurations
                dap_configurations = {
                    {
                        type = "go",
                        name = "Debug",
                        request = "launch",
                        program = "${file}"
                    },
                    {
                        type = "go",
                        name = "Debug Package",
                        request = "launch",
                        program = "${fileDirname}"
                    },
                    {
                        type = "go",
                        name = "Debug test", -- configuration for debugging test files
                        request = "launch",
                        mode = "test",
                        program = "${file}"
                    },
                    -- additional specialized configurations
                    {
                        type = "go",
                        name = "Debug test (go.mod)",
                        request = "launch",
                        mode = "test",
                        program = "./${relativeFileDirname}"
                    }
                },
                -- delve
                delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                    port = "${port}",
                    args = {},
                    build_flags = "",
                },
            })
            
            -- Register key bindings
            vim.keymap.set("n", "<leader>dg", "<cmd>lua require'dap-go'.debug()<CR>", { desc = "Debug Go Program" })
            vim.keymap.set("n", "<leader>dgt", "<cmd>lua require'dap-go'.debug_test()<CR>", { desc = "Debug Go Test" })
            vim.keymap.set("n", "<leader>dgl", "<cmd>lua require'dap-go'.debug_last()<CR>", { desc = "Debug Last Go" })
            
            -- Add to WhichKey if available
            pcall(function()
                local wk = require("which-key")
                wk.register({
                    ["<leader>dg"] = { "<cmd>lua require'dap-go'.debug()<CR>", "Debug Go Program" },
                    ["<leader>dgt"] = { "<cmd>lua require'dap-go'.debug_test()<CR>", "Debug Go Test" },
                    ["<leader>dgl"] = { "<cmd>lua require'dap-go'.debug_last()<CR>", "Debug Last Go" },
                })
            end)
        end
    },

    -- Make sure Treesitter has Go support
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- Add Go languages to ensure_installed list
            if opts.ensure_installed ~= "all" then
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
            end
        end,
    },
}
