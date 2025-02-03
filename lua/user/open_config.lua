local path = vim.fn.expand('<script>:h') .. '/lua/user/init.lua'

function OpenConfig()
  print(path)
  vim.cmd.edit(path)
end
