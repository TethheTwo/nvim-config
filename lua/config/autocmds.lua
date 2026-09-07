local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("General", { clear = true })

autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})



autocmd("FileType", {
  group = general,
  pattern = "tex",
  callback = function()
    vim.opt_local.foldmethod = "manual"
  end,
})

vim.filetype.add {
  extension = { tex = "tex" },
}
