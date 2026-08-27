# NvChad Config — TethheTwo

Personal Neovim configuration built on NvChad with Flexoki theme, 30 plugins, and custom features.

## Requirements

- **Neovim** >= 0.10
- **Ghostty** (for rainbow-delimiters and image preview via kitty graphics protocol)
- **live-server** (`npm i -g live-server`) for the live-server feature
- **Mason** (auto-installs LSP servers and formatters)

## Installation

```bash
git clone git@github.com:TethheTwo/nvim-config.git ~/.config/nvim
nvim
```

Plugins and LSP servers are installed automatically on first launch.

## Structure

```
.
├── init.lua                        # Entry point: leader key, lazy.nvim, ThemeSelect command
├── lua/
│   ├── chadrc.lua                  # Theme, palette (hl_override + hl_add), UI, statusline, nvdash
│   ├── rainbow-type-strategy.lua   # Custom rainbow-delimiters strategy (type + offset)
│   ├── config/
│   │   ├── autocmds.lua            # Yank highlight, LaTeX auto-compile, TeX fold
│   │   ├── keymaps.lua             # Core keymaps (navigation, windows, format, wrap)
│   │   ├── liveserver.lua          # Live-server toggle module
│   │   ├── nvdash.lua              # Custom dashboard with extmarks
│   │   ├── options.lua             # Editor options (indent=4, etc.)
│   │   └── statusline.lua          # Mode-color blending for statusline
│   └── plugins/
│       ├── completion.lua          # blink.cmp + LuaSnip
│       ├── conform.lua             # Formatters (per-filetype, ColumnLimit=9999)
│       ├── emmet.lua               # Emmet for HTML/CSS/JSX/TSX
│       ├── explorer.lua            # neo-tree
│       ├── extras.lua              # which-key, snacks, gitsigns, nvim-lint, autopairs
│       ├── latex.lua               # vimtex (Zathura + latexmk)
│       ├── lsp.lua                 # Mason + lspconfig (12 servers)
│       ├── markdown.lua            # render-markdown
│       ├── rainbow.lua             # rainbow-delimiters config
│       ├── smear.lua               # smear-cursor
│       ├── telescope.lua           # telescope + fzf-native
│       ├── terminal.lua            # toggleterm
│       ├── treesitter.lua          # treesitter (auto-install, folding)
│       └── ui.lua                  # base46, nvchad/ui, devicons, plenary, volt, menu, minty
```

## Plugins

| Plugin | Purpose | Source |
|---|---|---|
| `williamboman/mason.nvim` | LSP/formatter installer | `lsp.lua` |
| `neovim/nvim-lspconfig` | LSP configuration | `lsp.lua` |
| `saghen/blink.cmp` | Completion engine | `completion.lua` |
| `L3MON4D3/LuaSnip` + `friendly-snippets` | Snippets | `completion.lua` |
| `stevearc/conform.nvim` | Formatting | `conform.lua` + `extras.lua` |
| `mfussenegger/nvim-lint` | Linting (ruff, eslint_d) | `extras.lua` |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting, folding | `treesitter.lua` |
| `nvim-telescope/telescope.nvim` + `fzf-native` | fuzzy finder | `telescope.lua` |
| `nvim-neo-tree/neo-tree.nvim` | File explorer | `explorer.lua` |
| `akinsho/toggleterm.nvim` | Terminal manager | `terminal.lua` |
| `HiPhish/rainbow-delimiters.nvim` | Rainbow brackets by type+depth | `rainbow.lua` |
| `folke/which-key.nvim` | Keymap hints | `extras.lua` |
| `folke/snacks.nvim` | Indent guides, notifier, scroll, image preview, words | `extras.lua` |
| `lewis6991/gitsigns.nvim` | Git signs in gutter | `extras.lua` |
| `windwp/nvim-autopairs` | Auto-close brackets | `extras.lua` |
| `mattn/emmet-vim` | HTML/CSS/JSX expansion | `emmet.lua` |
| `sphamba/smear-cursor.nvim` | Cursor smear animation | `smear.lua` |
| `MeanderingProgrammer/render-markdown.nvim` | Markdown rendering | `markdown.lua` |
| `lervag/vimtex` | LaTeX compilation (Zathura) | `latex.lua` |
| `nvchad/base46` + `nvchad/ui` | NvChad core | `ui.lua` |
| `nvim-tree/nvim-web-devicons` | File icons | `ui.lua` |
| `nvzone/volt` + `nvzone/menu` + `nvzone/minty` | UI utilities | `ui.lua` |

## Keymaps

Leader key: `<Space>`

### Navigation

| Key | Mode | Action | Source |
|---|---|---|---|
| `;` | n | Enter command mode | `keymaps.lua` |
| `j` / `k` | n, x | Smart j/k (respects count, visual wrap) | `keymaps.lua` |
| `<A-j>` / `<A-k>` | n, x | Move line/selection up/down | `keymaps.lua` |
| `<Esc>` | n | Clear search highlight | `keymaps.lua` |

### Buffers & Tabs

| Key | Mode | Action | Source |
|---|---|---|---|
| `<Tab>` | n | Next buffer | `init.lua` |
| `<S-Tab>` | n | Previous buffer | `init.lua` |
| `<leader>x` | n | Close buffer | `keymaps.lua` |
| `]t` / `[t` | n | Next/previous tabpage | `keymaps.lua` |

### Windows

| Key | Mode | Action | Source |
|---|---|---|---|
| `<C-h/j/k/l>` | n | Navigate windows | `keymaps.lua` |
| `<C-Up/Down>` | n | Resize height | `keymaps.lua` |
| `<C-Left/Right>` | n | Resize width | `keymaps.lua` |

### Files & Search

| Key | Mode | Action | Source |
|---|---|---|---|
| `<leader>ff` | n | Find files | `telescope.lua` |
| `<leader>fg` | n | Live grep | `telescope.lua` |
| `<leader>fb` | n | Buffers | `telescope.lua` |
| `<leader>fr` | n | Recent files | `telescope.lua` |
| `<leader>fh` | n | Help tags | `telescope.lua` |
| `<leader>fk` | n | Keymaps | `telescope.lua` |
| `<leader>fs` | n | LSP document symbols | `telescope.lua` |
| `<leader>e` | n | Toggle neo-tree | `explorer.lua` |
| `<leader>E` | n | Focus neo-tree | `explorer.lua` |

### LSP

| Key | Mode | Action | Source |
|---|---|---|---|
| `gd` | n | Go to definition | `lsp.lua` |
| `gr` | n | Find references | `lsp.lua` |
| `gi` | n | Go to implementation | `lsp.lua` |
| `K` | n | Hover documentation | `lsp.lua` |
| `<C-k>` | n | Signature help | `lsp.lua` |
| `<leader>rn` | n | Rename symbol | `lsp.lua` |
| `<leader>ca` | n, x | Code action | `lsp.lua` |
| `<leader>D` | n | Type definition | `lsp.lua` |
| `<leader>d` | n | Diagnostic float (full message) | `lsp.lua` |
| `[d` / `]d` | n | Prev/next diagnostic | `lsp.lua` |
| `<leader>q` | n | Diagnostics to loclist | `lsp.lua` |

### Git (Gitsigns)

| Key | Mode | Action | Source |
|---|---|---|---|
| `]c` / `[c` | n | Next/previous hunk | `extras.lua` |
| `<leader>hs` | n, x | Stage hunk | `extras.lua` |
| `<leader>hr` | n, x | Reset hunk | `extras.lua` |
| `<leader>hp` | n | Preview hunk | `extras.lua` |
| `<leader>hb` | n | Blame line | `extras.lua` |
| `<leader>hd` | n | Diff this | `extras.lua` |
| `<leader>tb` | n | Toggle line blame | `extras.lua` |

### Terminal

| Key | Mode | Action | Source |
|---|---|---|---|
| `<C-\>` | n | Toggle terminal | `terminal.lua` |
| `<leader>tv` | n | Terminal (vertical) | `terminal.lua` |
| `<leader>tf` | n | Terminal (float) | `terminal.lua` |
| `<leader>tl` | n | Lazygit | `terminal.lua` |

### Editing & Formatting

| Key | Mode | Action | Source |
|---|---|---|---|
| `<leader>cf` | n | Format buffer | `keymaps.lua` |
| `<leader>cf` | v | Format selection | `keymaps.lua` |
| `<C-s>` | n, x | Save file | `keymaps.lua` |
| `<leader>w` | n | Save | `keymaps.lua` |
| `<leader>q` | n | Quit | `keymaps.lua` |
| `<leader>z` | n | Toggle line wrap | `keymaps.lua` |
| `<leader>th` | n | Theme picker | `init.lua` |

### Live Server

| Key | Mode | Action | Source |
|---|---|---|---|
| `<leader>ls` | n | Toggle live server (port 8080) | `liveserver.lua` |
| `<leader>lS` | n | Open live server in browser | `liveserver.lua` |

### Completion (Insert)

| Key | Mode | Action | Source |
|---|---|---|---|
| `<Tab>` | i | Select next / snippet forward | `completion.lua` |
| `<S-Tab>` | i | Select prev / snippet backward | `completion.lua` |
| `<C-j>` / `<C-k>` | i | Select next / prev | `completion.lua` |
| `<CR>` | i | Accept completion | `completion.lua` |
| `<C-b>` / `<C-f>` | i | Scroll doc down / up | `completion.lua` |

### Telescope (Insert)

| Key | Mode | Action | Source |
|---|---|---|---|
| `<C-j>` / `<C-k>` | i | Move selection | `telescope.lua` |

## Formatting

All formatters use 4-space indentation and effectively infinite line width (no line wrapping).

| Filetype | Formatter(s) | Args |
|---|---|---|
| `lua` | stylua | `--column-width 9999 --indent-type Spaces --indent-width 4` |
| `c`, `cpp` | clang-format | `BasedOnStyle: LLVM, ColumnLimit: 9999, IndentWidth: 4, UseTab: Never` |
| `python` | isort, black | `--line-length 9999` |
| `javascript`, `typescript`, `tsx`, `jsx` | prettier | `--print-width 9999 --tab-width 4` |
| `html`, `css`, `json`, `markdown`, `yaml` | prettier | `--print-width 9999 --tab-width 4` |
| `go` | goimports | (no line-limit option) |
| `latex` | latexindent | `defaultIndent: '    '` |

Format on save: **off** (use `<leader>cf` manually).

## LSP Servers

Auto-installed via Mason on first launch:

bashls, clangd, cssls, gopls, html, jsonls, lua_ls, marksman, pyright, rust_analyzer, texlab, ts_ls, vim-language-server, yamlls

Custom settings:
- `lua_ls`: recognizes `vim` global, loads Neovim runtime library
- `html`: validates HTML + CSS + JavaScript

## Tree-sitter

- Auto-installs parsers for every filetype opened
- Folding via treesitter expressions (`foldmethod=expr`, `foldlevel=99`)
- Highlight groups follow a custom Flexoki-based palette (see Theme section)

### Syntax palette (hl_override)

| Capture | Color | Used for |
|---|---|---|
| `@keyword`, `@keyword.*` | purple | if, for, return, while |
| `@keyword.import`, `@keyword.directive.*` | yellow | #include, #define, import |
| `@type.builtin` | cyan | int, void, char |
| `@function`, `@function.call`, `@function.builtin` | blue | function calls |
| `@function.macro`, `@constant`, `@constant.macro` | red | macros, constants |
| `@string.escape`, `@character` | green | \n, escape chars |
| `@number` | orange | numeric literals |
| `@variable`, `@variable.builtin` | white | variables, this/self |
| `@variable.parameter` | pink | function parameters |
| `@property` | blue | struct/class members |
| `@punctuation.delimiter` | teal | ; , |

### Syntax palette (hl_add — not in base46 default table)

| Capture | Color | Used for |
|---|---|---|
| `@keyword.type`, `@keyword.modifier`, `@type`, `@type.qualifier`, `@type.definition` | cyan | struct, const, static |
| `@boolean` | orange | true, false |
| `@label` | pink | labels |
| `@punctuation.special` | teal | special punctuation |
| `@comment.documentation` | grey | doc comments |

## Rainbow Delimiters

Plugin: `HiPhish/rainbow-delimiters.nvim`

Strategy: **custom** (`rainbow-type-strategy.lua`) — color depends on both nesting depth AND bracket type.

Type offsets (added to level):
| Type | Offset |
|---|---|
| `()` | 0 (base) |
| `[]` | +1 |
| `{}` | +2 |
| `<>` | +3 |

Colors cycle through 8 groups: Red, Yellow, Blue, Orange, Green, Violet, Cyan, Pink.

Example in C (`printf("hello %d\n", 42)`):
- Level 1 `()` = Red
- Level 1 `[]` = Yellow
- Level 1 `{}` = Blue
- Level 1 `<>` = Orange
- Nested: level rotates

In HTML: `<div>` and `</div>` are paired as one container; `<`/`>` get the angle offset color while the tag name gets the base level color.

## Theme

Theme: **Flexoki** (`flexoki.lua` in base46)

Toggle: `<leader>th` (opens a picker with favorite-star support on `<Tab>`, confirms on `<CR>`)

Favorite themes:
default-dark, everblush, flexoki, gruvbox, gruvchad, yoru, flexoki-light, hiberbee, midnight_breeze

### Palette highlights

| Group | Color |
|---|---|
| `@tag` (HTML) | blue |
| `@tag.attribute` (HTML) | orange |
| `@tag.delimiter` (HTML `<`/`>`) | base0F (grey-brown) |
| Rainbow delimiters | red, yellow, blue, orange, green, violet, cyan, pink |

## Custom Features

### Custom Dashboard (nvdash)

Fully reimplemented with extmarks: ASCII "TethheTwo" header, 7 action buttons (Find File, Recent Files, Find Word, Mason, Lazy, Themes, Quit), keymap reference table, and j/k navigation. Defined in `lua/config/nvdash.lua`.

### Statusline

Mode-colored statusline with rounded separators. Custom modules: mode icon, file (with git info), git branch, live server indicator. Mode-to-color blending handled in `lua/config/statusline.lua`.

### Live Server

Toggle a `live-server` dev server on port 8080 (`<leader>ls`). Auto-finds root by looking for `index.html`. Open in browser with `<leader>lS`.

### LaTeX

- vimtex with Zathura PDF viewer and latexmk
- Auto-compile on save (`lualatex -interaction=nonstopmode`)
- TeX filetype: manual fold method

### Yank Highlight

Yanked text flashes with `IncSearch` highlight for 150ms.

### Smear Cursor

Smear-cursor animation (default settings) enabled globally.

## Known Conflicts

| Key | Mapping 1 | Mapping 2 | Winner |
|---|---|---|---|
| `<leader>q` | `:q<CR>` (global, `keymaps.lua`) | `vim.diagnostic.setloclist` (buffer-local, `lsp.lua`) | LSP in LSP buffers, quit elsewhere |
| `<leader>th` | `ThemeSelect` (`init.lua`) | `ToggleTerm direction=horizontal` (`terminal.lua`) | ThemeSelect (loads last) |
