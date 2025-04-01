-- lua/plugins/lsp.lua - Unified LSP configuration with Go support
return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP Management
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },
        },
        -- Don't lazy load - ensure LSP is available immediately
        lazy = false,
        priority = 1000,
        config = function()
            -- Set up Mason first
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            -- Configure mason-lspconfig
            require("mason-lspconfig").setup({
                -- Ensure these servers are installed
                ensure_installed = {
                    "clangd", -- C/C++ support
                    "ts_ls", -- JavaScript/TypeScript
                    "html", -- HTML
                    "cssls", -- CSS
                    "emmet_ls", -- Emmet
                    "gopls", -- Go support
                },
                automatic_installation = true,
            })

            -- LSP settings
            local lspconfig = require("lspconfig")

            -- Default on_attach function to setup keybindings when LSP connects
            local on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- LSP keybindings
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, opts)

                -- Add keybinding for which-key if it exists (using CLASSIC format)
                local ok, wk = pcall(require, "which-key")
                if ok then
                    wk.register({
                        ["<leader>lD"] = { vim.lsp.buf.type_definition, "Type Definition" },
                        ["<leader>lr"] = { vim.lsp.buf.rename, "Rename" },
                        ["<leader>la"] = { vim.lsp.buf.code_action, "Code Action" },
                        ["<leader>lf"] = { function() vim.lsp.buf.format { async = true } end, "Format" },
                        ["<leader>li"] = { vim.lsp.buf.implementation, "Implementation" },
                        ["<leader>lh"] = { vim.lsp.buf.signature_help, "Signature Help" },
                        ["<leader>ld"] = { vim.diagnostic.open_float, "Line Diagnostics" },
                        ["<leader>ln"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
                        ["<leader>lp"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
                    })
                end

                -- Set autocommands conditional on server capabilities
                if client.server_capabilities.documentHighlightProvider then
                    -- Highlight references when cursor is held
                    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
                    vim.api.nvim_create_autocmd("CursorHold", {
                        group = "lsp_document_highlight",
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        group = "lsp_document_highlight",
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end

            -- Setup capabilities
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = has_cmp
                and cmp_nvim_lsp.default_capabilities()
                or vim.lsp.protocol.make_client_capabilities()

            ---------------------------
            -- C/C++ (clangd) Setup --
            ---------------------------
            -- More reliable clangd detection and setup
            local function setup_clangd()
                -- First try Mason's clangd
                local mason_registry = require("mason-registry")
                local is_installed_by_mason = mason_registry.is_installed("clangd")

                -- Simplify clangd setup with robust defaults
                lspconfig.clangd.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                        "--all-scopes-completion",
                        "--pch-storage=memory",
                        "-j=4",
                        "--offset-encoding=utf-16",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
                })

                -- Add cpp utility functions for compile_flags generation
                local compiler_paths = {}

                -- Try to get system include paths
                local function get_cpp_include_paths()
                    local paths = {}
                    local get_paths_cmd = io.popen(
                    'echo | g++ -Wp,-v -x c++ - -fsyntax-only 2>&1 | grep "^ /" | tr -d "\n"')

                    if get_paths_cmd then
                        local paths_str = get_paths_cmd:read("*a")
                        get_paths_cmd:close()

                        if paths_str and paths_str ~= "" then
                            -- Parse and add paths
                            for path in string.gmatch(paths_str, "%S+") do
                                table.insert(paths, "-I" .. path)
                            end
                        end
                    end

                    -- If we didn't get any paths, add some defaults
                    if #paths == 0 then
                        table.insert(paths, "-I/usr/include/c++/11")
                        table.insert(paths, "-I/usr/include/x86_64-linux-gnu/c++/11")
                        table.insert(paths, "-I/usr/include/c++/10")
                        table.insert(paths, "-I/usr/include/x86_64-linux-gnu/c++/10")
                        table.insert(paths, "-I/usr/include")
                        table.insert(paths, "-I/usr/local/include")
                    end

                    return paths
                end

                compiler_paths = get_cpp_include_paths()

                -- Create compile_flags.txt helper function with customizable C++ standard
                _G.create_cpp_compile_flags = function(cpp_std)
                    -- If no standard specified, ask user
                    if not cpp_std then
                        local options = {
                            "c++98", "c++03", "c++11", "c++14",
                            "c++17", "c++20", "c++23", "gnu++17", "gnu++20"
                        }

                        vim.ui.select(options, {
                            prompt = "Select C++ Standard:",
                            format_item = function(item)
                                return item
                            end,
                        }, function(choice)
                            if choice then
                                create_cpp_compile_flags_with_standard(choice)
                            end
                        end)
                    else
                        create_cpp_compile_flags_with_standard(cpp_std)
                    end
                end

                -- Implementation with specific standard
                function create_cpp_compile_flags_with_standard(cpp_std)
                    local cwd = vim.fn.getcwd()
                    local file = io.open(cwd .. "/compile_flags.txt", "w")
                    if file then
                        file:write("-std=" .. cpp_std .. "\n")
                        file:write("-Wall\n")
                        file:write("-Wextra\n")

                        -- Add the include paths we found earlier
                        for _, path in ipairs(compiler_paths) do
                            file:write(path .. "\n")
                        end

                        file:close()
                        vim.notify("Created compile_flags.txt with " .. cpp_std .. " in " .. cwd, vim.log.levels.INFO)

                        -- Create .clangd file for additional settings
                        local clangd_file = io.open(cwd .. "/.clangd", "w")
                        if clangd_file then
                            clangd_file:write("CompileFlags:\n")
                            clangd_file:write("  Add: [-std=" .. cpp_std .. "]\n")
                            clangd_file:write("  Compiler: g++\n\n")
                            clangd_file:write("Index:\n")
                            clangd_file:write("  Background: true\n\n")
                            clangd_file:write("Diagnostics:\n")
                            clangd_file:write("  UnusedIncludes: Strict\n")
                            clangd_file:write("  MissingIncludes: Strict\n")
                            clangd_file:close()
                            vim.notify("Created .clangd configuration file", vim.log.levels.INFO)
                        end

                        -- Restart the LSP
                        vim.cmd("LspRestart")
                    else
                        vim.notify("Failed to create compile_flags.txt", vim.log.levels.ERROR)
                    end
                end

                -- Add a command to create compile_flags.txt with a specific C++ standard
                vim.api.nvim_create_user_command('CreateCppCompileFlags', function(opts)
                    local cpp_std = opts.args ~= "" and opts.args or nil
                    _G.create_cpp_compile_flags(cpp_std)
                end, {
                    nargs = "?",
                    complete = function()
                        return { "c++98", "c++03", "c++11", "c++14", "c++17", "c++20", "c++23", "gnu++17", "gnu++20" }
                    end
                })

                -- Create function to fix include errors in current buffer with customizable C++ standard
                _G.fix_cpp_includes = function(cpp_std)
                    -- If no standard specified, ask user
                    if not cpp_std then
                        local options = {
                            "c++98", "c++03", "c++11", "c++14",
                            "c++17", "c++20", "c++23", "gnu++17", "gnu++20"
                        }

                        vim.ui.select(options, {
                            prompt = "Select C++ Standard:",
                            format_item = function(item)
                                return item
                            end,
                        }, function(choice)
                            if choice then
                                fix_cpp_includes_with_standard(choice)
                            end
                        end)
                    else
                        fix_cpp_includes_with_standard(cpp_std)
                    end
                end

                -- Implementation with specific standard
                function fix_cpp_includes_with_standard(cpp_std)
                    -- Get the current buffer's directory
                    local buf_dir = vim.fn.expand("%:p:h")

                    -- Create compile_flags.txt in the buffer's directory
                    local file = io.open(buf_dir .. "/compile_flags.txt", "w")
                    if file then
                        file:write("-std=" .. cpp_std .. "\n")
                        file:write("-Wall\n")
                        file:write("-Wextra\n")

                        -- Add the include paths we found earlier
                        for _, path in ipairs(compiler_paths) do
                            file:write(path .. "\n")
                        end

                        file:close()

                        -- Create .clangd file for additional settings
                        local clangd_file = io.open(buf_dir .. "/.clangd", "w")
                        if clangd_file then
                            clangd_file:write("CompileFlags:\n")
                            clangd_file:write("  Add: [-std=" .. cpp_std .. "]\n")
                            clangd_file:write("  Compiler: g++\n\n")
                            clangd_file:write("Index:\n")
                            clangd_file:write("  Background: true\n\n")
                            clangd_file:write("Diagnostics:\n")
                            clangd_file:write("  UnusedIncludes: Strict\n")
                            clangd_file:write("  MissingIncludes: Strict\n")
                            clangd_file:close()
                        end

                        vim.notify(
                        "Created compile_flags.txt with " .. cpp_std .. " in " .. buf_dir .. ". LSP will reload soon.",
                            vim.log.levels.INFO)

                        -- Restart the LSP for this buffer
                        vim.cmd("LspRestart")
                    else
                        vim.notify("Failed to create compile_flags.txt", vim.log.levels.ERROR)
                    end
                end

                -- Add command to fix includes for current buffer with a specific C++ standard
                vim.api.nvim_create_user_command('FixCppIncludes', function(opts)
                    local cpp_std = opts.args ~= "" and opts.args or nil
                    _G.fix_cpp_includes(cpp_std)
                end, {
                    nargs = "?",
                    complete = function()
                        return { "c++98", "c++03", "c++11", "c++14", "c++17", "c++20", "c++23", "gnu++17", "gnu++20" }
                    end
                })

                -- Add to WhichKey if available - USING CLASSIC FORMAT
                local ok, wk = pcall(require, "which-key")
                if ok then
                    wk.register({
                        ["<leader>lc"] = { ":CreateCppCompileFlags<CR>", "Create compile_flags.txt" },
                        ["<leader>lx"] = { ":FixCppIncludes<CR>", "Fix C++ Includes" },
                        ["<leader>lc98"] = { ":CreateCppCompileFlags c++98<CR>", "C++98 Project" },
                        ["<leader>lc11"] = { ":CreateCppCompileFlags c++11<CR>", "C++11 Project" },
                        ["<leader>lc14"] = { ":CreateCppCompileFlags c++14<CR>", "C++14 Project" },
                        ["<leader>lc17"] = { ":CreateCppCompileFlags c++17<CR>", "C++17 Project" },
                        ["<leader>lc20"] = { ":CreateCppCompileFlags c++20<CR>", "C++20 Project" },
                    })
                end
            end

            -------------------------
            -- Web Server Setup --
            -------------------------
            -- Configure web development servers
            local function setup_web_servers()
                -- JavaScript/TypeScript
                lspconfig.ts_ls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    filetypes = {
                        "javascript", "javascriptreact", "javascript.jsx",
                        "typescript", "typescriptreact", "typescript.tsx"
                    },
                    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
                    single_file_support = true,
                })

                -- HTML
                lspconfig.html.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    filetypes = { "html" },
                    root_dir = lspconfig.util.root_pattern("package.json", ".git"),
                    single_file_support = true,
                })

                -- CSS
                lspconfig.cssls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    filetypes = { "css", "scss", "less" },
                    root_dir = lspconfig.util.root_pattern("package.json", ".git"),
                    single_file_support = true,
                })

                -- Emmet
                lspconfig.emmet_ls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    filetypes = {
                        "html", "css", "scss", "javascript",
                        "javascriptreact", "typescript", "typescriptreact"
                    },
                    root_dir = lspconfig.util.root_pattern("package.json", ".git"),
                    single_file_support = true,
                })
            end
            
            -------------------------
            -- Go Server Setup --
            -------------------------
            local function setup_go_servers()
                -- Go language server
                lspconfig.gopls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    cmd = {"gopls", "serve"},
                    filetypes = {"go", "gomod", "gowork", "gotmpl"},
                    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                            matcher = "fuzzy",
                        },
                    },
                })
                
                -- Add Go-specific commands
                local ok, wk = pcall(require, "which-key")
                if ok then
                    wk.register({
                        ["<leader>lgo"] = { ":GoImports<CR>", "Organize Imports" },
                        ["<leader>lgf"] = { ":GoFmt<CR>", "Format Go Code" },
                    })
                end
            end

            -- Execute server setup functions
            setup_clangd()
            setup_web_servers()
            setup_go_servers()
        end,
    },

    -- Formatter configuration
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                -- C/C++
                c = { "clang_format" },
                cpp = { "clang_format" },
                ["c.doxygen"] = { "clang_format" },
                ["cpp.doxygen"] = { "clang_format" },

                -- Web
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                
                -- Go formatters
                go = { "gofumpt", "goimports" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
                
                -- Format Go files on save
                go = { "gofumpt", "goimports" },
            },
        },
    },

    -- WhichKey integration for LSP commands (USING CLASSIC FORMAT)
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            },
            -- Use win instead of window (fixes deprecation warning)
            win = {
                border = "single",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 2, 2, 2, 2 },
            },
        },
    },
}
