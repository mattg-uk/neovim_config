local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

if ((not mason_ok) or (not mason_lspconfig_ok) or (not lspconfig_ok)) then
  return
end

-- generic options for lsp display and lsp config
local options = require("user.lsp.options")

-- Define a look-up table of available extended server files
local settings_directory = vim.fn.expand('<script>:h') .. '/lua/user/lsp/settings'
local settings_file_index = vim.fn.readdir(settings_directory, [[v:val =~ '\.lua$']])
local settings_lua_file_exists = {}
for _, filename in ipairs(settings_file_index) do
  settings_lua_file_exists[filename] = true
end

local function setup_server(server_name)
  local opts = {
    on_attach = options.on_attach,
    capabilities = options.capabilities,
  }

  if settings_lua_file_exists[server_name .. ".lua"] then
    local config_file = "user.lsp.settings." .. server_name
    local extra_opts = require(config_file)
    opts = vim.tbl_deep_extend("force", extra_opts, opts)
  end

  lspconfig[server_name].setup(opts)
end

-- Setup order is mason, mason-lspconfig, followed by the servers
mason.setup()
mason_lspconfig.setup()

for _, server_name in pairs(mason_lspconfig.get_installed_servers()) do
  setup_server(server_name)
end

-- generic configuration of lsp display options
options.lsp_generic_setup()
