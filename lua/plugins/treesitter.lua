return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      local au = vim.api.nvim_create_augroup("TSAutoInstall", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = au,
        callback = function()
          local lang = vim.bo.filetype
          if not lang or lang == "" then
            return
          end
          local nt = require("nvim-treesitter")
          if
            vim.list_contains(nt.get_available(), lang)
            and not vim.list_contains(nt.get_installed(), lang)
          then
            nt.install({ lang })
          end
        end,
      })
    end,
  },
}
