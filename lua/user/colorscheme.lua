local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
  return
end

local transparencyState = false
function ToggleTransparency()
  transparencyState = not transparencyState
  if transparencyState then
    tokyonight.setup {
      transparent = true,
      styles = {
        sidebars = "transparent"
      }
    }
  else
    tokyonight.setup { transparent = false }
  end
  vim.cmd [[ colorscheme tokyonight ]]
end

function TogglePartialTransparency()
  transparencyState = not transparencyState
  if transparencyState then
    vim.api.nvim_set_hl(
      0,
      "Normal",
      { bg = "none", fg = "none" }
    )
  else
    tokyonight.setup { transparent = false }
    vim.cmd [[ colorscheme tokyonight ]]
  end
end

vim.cmd [[ colorscheme tokyonight ]]
