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

autocmd("BufWritePost", {
  group = general,
  pattern = "*.tex",
  callback = function()
    local bufname = vim.fn.expand "%:r"
    vim.fn.system(string.format("lualatex -interaction=nonstopmode %s.tex", bufname))
    vim.notify(string.format("Compiled %s.tex with lualatex", bufname), vim.log.levels.INFO)
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
