-- Web development tools (without LSP configuration)
return {
    -- Emmet for HTML/CSS coding
    {
        "mattn/emmet-vim",
        ft = { "html", "css", "javascriptreact", "typescriptreact" }
    },

    -- Auto-closing tags for JSX/HTML
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "javascriptreact", "typescriptreact" },
        config = true,
    },

    -- Formatter configuration (specific to web files)
    {
        "stevearc/conform.nvim",
        optional = true,
        ft = { "javascript", "typescript", "html", "css", "json" },
        opts = {
            -- Ensure proper web formatting with prettier
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
            },
        },
    },
}
