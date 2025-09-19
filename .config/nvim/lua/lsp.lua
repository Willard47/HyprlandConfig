-- Minimal LSP setup
local nvim_lsp = require('lspconfig')

-- Example: setup for Pyright (Python)
nvim_lsp.pyright.setup{}

-- Example: setup for tsserver (TypeScript/JS)
nvim_lsp.tsserver.setup{}

-- You can add more language servers as needed
