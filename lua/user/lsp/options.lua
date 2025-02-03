local M = {}

local path = ...

M.virtual_text_toggle = function()
    local virtual_text_active = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not virtual_text_active })
end

M.lsp_generic_setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = true,
        signs = {
            active = signs,
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    -- If no lsp is available, neovim will report a warning
    -- Prevents use of Format causing an error
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format()' ]]

    local quoted_command = [['lua require("]] .. path .. [[").virtual_text_toggle()']]
    vim.cmd([[ command! VirtualTextToggle execute ]] .. quoted_command)
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    keymap(bufnr, 'i', '<C-c>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap(bufnr, 'n', '<C-c>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    keymap(bufnr, 'n', '<leader>do', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<CR>', opts)
    keymap(bufnr, 'n', '<leader>da', '<cmd>lua vim.diagnostic.open_float(0, { scope = "buffer" })<CR>', opts)
    keymap(bufnr, 'n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    keymap(bufnr, 'n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    keymap(bufnr, 'n', '<leader>dl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

    keymap(bufnr, 'n', '<leader>V', '<cmd>:VirtualTextToggle<CR>', opts)
end

-- Add functionality dependent on the allowed client capabilities here
local function lsp_client_dependent_callback(_)
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    lsp_client_dependent_callback(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
