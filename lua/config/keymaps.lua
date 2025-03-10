-- Set leader key
vim.g.mapleader = " "

-- Helper function for mapping keys
local function map(mode, lhs, rhs, opts)
    local options = { silent = true, noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Stay in indent mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Neo-tree
map("n", "<leader>e", ":Neotree toggle<CR>")
map("n", "<leader>o", ":Neotree focus<CR>")

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>c", ":bd<CR>")

-- Clear highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>")

-- Save file
map("n", "<leader>w", "<cmd>w<CR>")

-- Close window
map("n", "<leader>q", "<cmd>q<CR>")

-- Better paste
map("v", "p", '"_dP')

-- Escape terminal mode
map("t", "<Esc>", "<C-\\><C-n>")

-- Toggle file explorer
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Explorer" })

-- Telescope mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find Text" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find Help Tags" })

-- ADDED: Theme keybindings - make these refer to global commands
map("n", "<leader>tl", ":ThemeList<CR>", { desc = "List themes" })
map("n", "<leader>ts", ":ThemeSelect<CR>", { desc = "Select theme" })
map("n", "<leader>tn", ":ThemeNext<CR>", { desc = "Next theme" })
map("n", "<leader>tp", ":ThemePrev<CR>", { desc = "Previous theme" })
