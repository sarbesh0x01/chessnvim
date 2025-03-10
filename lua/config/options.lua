-- Basic editor settings
local opt = vim.opt

-- Line numbers
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers

-- Tabs & Indentation
opt.tabstop = 2        -- 2 spaces for tabs
opt.shiftwidth = 2     -- 2 spaces for indent width
opt.expandtab = true   -- Expand tabs to spaces
opt.autoindent = true  -- Copy indent from current line when starting new one
opt.smartindent = true -- Smart autoindenting when starting new line

-- Line wrapping
opt.wrap = false -- Disable line wrapping

-- Search settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true  -- If you include mixed case in search, assumes you want case-sensitive

-- Appearance
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.signcolumn = "yes"   -- Always show the signcolumn
opt.cmdheight = 1        -- Give more space for displaying messages
opt.scrolloff = 8        -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8    -- Keep 8 columns left/right of cursor
opt.showmode = true      -- Show mode in command line (old-style)
opt.ruler = true         -- Shows cursor position (old-style)
opt.laststatus = 2       -- Always show statusline
opt.showcmd = true       -- Show command in last line (old-style)

-- Cursor
opt.guicursor = "n-v-c-i:block" -- Use block cursor in all modes for old-style look

-- Backup/Swap/Undo
opt.backup = false                                 -- Don't create backups
opt.swapfile = false                               -- Don't create swap files
opt.undofile = true                                -- Persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- undo directory

-- Window
opt.splitbelow = true -- Split horizontal windows below
opt.splitright = true -- Split vertical windows to the right

-- Performance
opt.updatetime = 300 -- Faster completion
opt.timeout = true   -- Enable timeout for key sequences
opt.timeoutlen = 500 -- Faster key sequence completion
opt.ttimeoutlen = 10 -- Fast terminal timeout

-- Misc
opt.backspace = "indent,eol,start" -- Allow backspace over everything
opt.clipboard = "unnamedplus"      -- Access system clipboard
opt.confirm = true                 -- Confirm before closing unsaved buffers
opt.mouse = "a"                    -- Enable mouse in all modes
opt.conceallevel = 0               -- Show `` in markdown files

-- Statusline (old-style)
vim.opt.statusline = " %f %m %r %h %w%= %y [%l,%c] [%P] "
