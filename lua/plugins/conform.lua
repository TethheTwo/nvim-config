return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        go = { "goimports" },
        latex = { "latexindent" },
      },
      formatters = {
        ["clang-format"] = {
          args = { "-assume-filename", "$FILENAME", "-style={BasedOnStyle: LLVM, ColumnLimit: 9999, IndentWidth: 4, UseTab: Never}" },
        },
        prettier = {
          args = { "--stdin-filepath", "$FILENAME", "--print-width", "9999", "--tab-width", "4" },
        },
        black = {
          args = { "--stdin-filename", "$FILENAME", "--quiet", "--line-length", "9999", "-" },
        },
        isort = {
          args = function(_, ctx)
            return {
              "--stdout",
              "--line-ending",
              require("conform.util").buf_line_ending(ctx.buf),
              "--filename",
              "$FILENAME",
              "--line-length",
              "9999",
              "-",
            }
          end,
        },
        stylua = {
          args = { "--search-parent-directories", "--respect-ignores", "--stdin-filepath", "$FILENAME", "--column-width", "9999", "--indent-type", "Spaces", "--indent-width", "4", "-" },
        },
        latexindent = {
          args = { "-", "-y", "defaultIndent: '    '" },
        },
      },
    },
  },
}
