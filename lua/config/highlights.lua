-- lua/config/highlights.lua
-- Custom highlight groups to enhance Neo-tree, Dashboard, and other UI elements
local M = {}

function M.setup()
    -- Dashboard highlights
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#dfa752", bold = true })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#8ec07c" })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a89984", italic = true })

    -- NeoTree highlights
    vim.api.nvim_set_hl(0, "NeoTreeTabActive", { fg = "#e2c08d", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparator", { fg = "#3e4452" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#3e4452" })
    vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#e2c08d", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#e2c08d" })
    vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#e2c08d", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "NeoTreeSymlink", { fg = "#c678dd" })
    vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#e06c75" })

    -- Git status highlights
    vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e2c08d" })
    vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "NeoTreeGitRenamed", { fg = "#c678dd" })
    vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#e06c75", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#d19a66" })
    vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#5c6370" })

    -- File type specific highlights for better visual organization
    vim.api.nvim_set_hl(0, "NeoTreeFileTypeHeader", { fg = "#61afef", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeFileTypeSource", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "NeoTreeFileTypeConfig", { fg = "#e2c08d" })
    vim.api.nvim_set_hl(0, "NeoTreeFileTypeData", { fg = "#56b6c2" })
end

-- Apply the highlights when this module is loaded
M.setup()

-- Return the module to enable reloading
return M
