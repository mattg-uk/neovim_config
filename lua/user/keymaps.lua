local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- No one actually types CTRL-h in insert mode
keymap("i", "<C-h>", "<Esc><C-w>h", opts)
keymap("i", "<C-j>", "<Esc><C-w>j", opts)
keymap("i", "<C-k>", "<Esc><C-w>k", opts)
keymap("i", "<C-l>", "<Esc><C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down NORMAL mode
keymap("n", "<A-j>", "<Esc>:m .+1<CR>", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>", opts)

-- Move text up and down INSERT mode
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)

-- Insert -- exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "<C-i>", "<ESC>", opts)

-- clear highlighting
keymap("n", "<leader>h", "<cmd>noh<cr>", opts)

-- 'Save'
keymap("i", "<C-s>", "<cmd>:Format<CR><cmd>w<cr><ESC>", opts)
keymap("n", "<C-s>", "<cmd>:Format<CR><cmd>w<cr>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)

keymap("n", "<leader>v", "<cmd>vsplit<cr>", opts)

-- Terminal --
keymap("t", "<ESC>", "<C-\\><C-n>", opts)
keymap("t", "<C-k>", "<C-\\><C-n><c-w>k", opts)
keymap("t", "<C-j>", "<C-\\><C-n><c-w>j", opts)
keymap("t", "<C-h>", "<C-\\><C-n><c-w>h", opts)
keymap("t", "<C-l>", "<C-\\><C-n><c-w>l", opts)

-- telescope
keymap('n', '<leader>f',
  "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
  opts)
keymap("n", "<leader>t", "<cmd>Telescope live_grep<cr>", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Function keys configuration
keymap("n", "<F1>", "<C-w>t", opts)
keymap("n", "<leader>T", "<cmd>lua ToggleTransparency()<CR>", opts)
keymap("n", "<leader><C-t>", "<cmd>lua TogglePartialTransparency()<CR>", opts)

-- Toggleterm open is configured on F2

-- Close current buffer
keymap("n", "<F3>", ":Bdelete<CR>", opts)
keymap("i", "<F3>", "<ESC>:Bdelete<CR>", opts)
-- adding shift aggressively closes the buffer (no save)
keymap("n", "<F15>", ":Bdelete!<CR>", opts)

-- open the user/init.lua config
keymap("n", "<F4>", "<cmd>lua OpenConfig()<CR>", opts)
