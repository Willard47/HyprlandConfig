-- Basic keymaps for Neovim
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Normal mode
map('n', '<Leader>e', ':NvimTreeToggle<CR>', opts)  -- example: toggle file tree
map('n', '<Leader>f', ':Telescope find_files<CR>', opts)

-- Insert mode
map('i', 'jk', '<Esc>', opts)
