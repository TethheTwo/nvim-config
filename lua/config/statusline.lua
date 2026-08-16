local M = {}

local mode_colors = {
  Normal = "nord_blue",
  Visual = "cyan",
  Insert = "dark_purple",
  Terminal = "green",
  NTerminal = "yellow",
  Replace = "orange",
  Confirm = "teal",
  Command = "green",
  Select = "blue",
}

local apply = function()
  local ok, base46 = pcall(require, "base46")
  if not ok then
    return
  end

  local ok2, colors = pcall(base46.get_theme_tb, "base_30")
  if not ok2 or not colors or not colors.yellow then
    return
  end

  local mix = require("base46.colors").mix
  local yellow = colors.yellow

  for mode, col in pairs(mode_colors) do
    local mc = colors[col]
    if mc then
      local blend = mix(mc, yellow, 50)
      vim.api.nvim_set_hl(0, "St_" .. mode .. "ModeSep", { fg = mc, bg = blend })
      vim.api.nvim_set_hl(0, "St_" .. mode .. "Sep2", { fg = blend, bg = yellow })
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
vim.api.nvim_create_autocmd("User", { pattern = "NvThemeReload", callback = apply })

return M
