return {
  {
    "mattn/emmet-vim",
    ft = {
      "html", "htmldjango", "css", "scss", "sass", "less",
      "javascriptreact", "typescriptreact", "vue", "svelte",
      "eruby", "ejs", "php", "xml", "markdown",
    },
    init = function()
      vim.g.user_emmet_leader_key = "<C-y>"
    end,
  },
}
