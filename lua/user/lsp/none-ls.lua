local null_ls_ok, null_ls = pcall(require, "null-ls")

if not null_ls_ok then
  return
end

-- Note, this is calling the globally installed version of black
local sources = {
  null_ls.builtins.formatting.black.with({
    extra_args = { "--line-length=100" }
  }),
}

null_ls.setup({ sources = sources })
