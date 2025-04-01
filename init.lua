--Bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to space before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set GUI font for icons to render properly
if vim.fn.has("gui_running") == 1 then
    vim.opt.guifont = "FiraCode Nerd Font:h12" -- Use a Nerd Font for proper icon rendering
end

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.highlights")
require("config.keymap_help")
require("config.diagnostics").setup() -- Load diagnostic configuration
require('config.youtube_standalone').setup()

-- Set author information for ChessDoc (will be available globally)
vim.g.chessdoc_author = "Sarbesh KC"

-- Configure Go tools and settings
vim.g.go_fmt_command = "gofumpt"
vim.g.go_imports_autosave = 1
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_operators = 1

-- Setup lazy.nvim
require("lazy").setup({
    -- Import all plugins from the lua/plugins directory
    { import = "plugins" },
}, {
    change_detection = {
        notify = false, -- Don't show notifications when plugin files change
    },
    install = {
        colorscheme = { "gruvbox" }, -- Try to load this colorscheme when installing
    },
    ui = {
        border = "single", -- Border style for UI elements
        icons = {
            cmd = " ",
            config = " ",
            event = " ",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "● ",
            not_loaded = "○ ",
            plugin = " ",
            runtime = " ",
            require = "󰢱 ",
            source = " ",
            start = " ",
            task = "✔ ",
            list = {
                "●",
                "➜",
                "★",
                "‒",
            },
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Post-initialization message
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
        -- Check if Go tools are installed
        local go_ok = vim.fn.executable("go") == 1
        if go_ok then
            vim.notify("♟️ Go development environment loaded!", vim.log.levels.INFO)
        else
            vim.notify("Go executable not found. Please install Go for full functionality.", vim.log.levels.WARN)
        end
    end,
})
