return {
  {
    "lervag/vimtex",
    lazy = false,
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_manual = 1
    end,
    config = function()
      vim.g.vimtex_mappings_enabled = 1
      vim.g.vimtex_format_enabled = 1
    end,
  },
}
