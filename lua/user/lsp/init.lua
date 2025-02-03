-- This is a delegation file to keep all the calls for lsp related config files together and in the
-- correct order

-- This file sets up mason, mason-lspconfig, and the lspconfigs for the servers
require "user.lsp.lspconfig"

-- Configuration for debug adapter, and also for nvim-dap-ui, etc
require "user.lsp.nvim-dap"

-- Configuration for file formatters etc, as pseudo LSP (none-ls)
require "user.lsp.none-ls"
