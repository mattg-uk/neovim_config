local config_status_ok, neodev = pcall(require, "neodev")
if config_status_ok then
  neodev.setup({
    -- use defaults
  })
end


return {
  settings = {

    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
