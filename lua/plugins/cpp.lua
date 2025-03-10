-- C/C++ development support (without LSP configuration)
return {
    -- C++ specific plugins can go here, but we've moved LSP config to lsp.lua

    -- Formatter configuration (specific to C/C++)
    {
        "stevearc/conform.nvim",
        optional = true,
        ft = { "c", "cpp", "h", "hpp" },
        opts = {
            -- Ensure proper C++ formatting with clang-format
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
            },
        },
    },

    -- Additional C++ tools can be added here if needed
}
