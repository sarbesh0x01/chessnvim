-- Configure diagnostic signs and appearance
local M = {}

function M.setup()
    -- Define diagnostic signs
    local signs = {
        { name = "DiagnosticSignError", text = " ", texthl = "DiagnosticSignError" },
        { name = "DiagnosticSignWarn",  text = " ", texthl = "DiagnosticSignWarn" },
        { name = "DiagnosticSignHint",  text = " ", texthl = "DiagnosticSignHint" },
        { name = "DiagnosticSignInfo",  text = " ", texthl = "DiagnosticSignInfo" },
    }

    -- Set diagnostic signs
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            text = sign.text,
            texthl = sign.texthl,
            numhl = sign.texthl,
        })
    end

    -- Configure diagnostics display
    vim.diagnostic.config({
        virtual_text = {
            prefix = '●', -- Dot as prefix for virtual text
            source = "if_many",
        },
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Diagnostic colors
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#db4b4b" })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0db9d7" })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#10B981" })

    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0db9d7" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#10B981" })

    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", bg = "#362222" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e0af68", bg = "#363026" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0db9d7", bg = "#253038" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#10B981", bg = "#253028" })

    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#db4b4b", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#e0af68", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = "#0db9d7", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#10B981", undercurl = true })
end

return M
