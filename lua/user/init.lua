-- Basic options such as tabs and key-bindings
require "user.options"
require "user.keymaps"

-- Language Server Protocol interface, provides language specific completion, error messages and cross references
require "user.lsp"

-- Configuration for the packer plugin manager
require "user.plugins"

-- Colorscheme
require "user.colorscheme"

-- Provide syntax highlighting, git highlighting
require "user.treesitter"
require "user.gitsigns"

-- Provides completion for buffers, command lines, and LSP interface
require "user.cmp"

-- Comment blocks
require "user.comment"

-- Filesearches and grepping, nice file browser
require "user.telescope"
require "user.nvim-tree"

-- Allows easy manipulation of multiple buffers in a single window, akin to 'browser tabs'
require "user.bufferline"

-- Friendly status bar
require "user.lualine"

-- Easy access to an integrated terminal
require "user.toggleterm"

-- lua command OpenConfig() to open this file
require("user.open_config")
