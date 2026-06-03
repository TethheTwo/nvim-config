local M = {}
local api = vim.api
local fn = vim.fn
local strw = api.nvim_strwidth

local rect_ns = api.nvim_create_namespace "nvdash_rect"
local active_idx = nil

local function btn_gap(txt1, txt2, max_str_w)
  local spacing = max_str_w - strw(txt1) - #txt2
  return txt1 .. string.rep(" ", spacing) .. txt2
end

local function get_colors()
  local ok, colors = pcall(dofile, vim.g.base46_cache .. "colors")
  return ok and colors or nil
end

local function ensure_hls()
  local colors = get_colors()
  if not colors then return end
  api.nvim_set_hl(0, "NvdashBtnRect", { fg = colors.light_grey, bg = colors.one_bg2 })
  api.nvim_set_hl(0, "NvdashBtnRectSel", { fg = colors.white, bg = colors.nord_blue })
  api.nvim_set_hl(0, "NvdashHeader", { fg = colors.nord_blue, bold = true })
end

local function map(keys, action, buf)
  for _, v in ipairs(keys) do
    vim.keymap.set("n", v, action, { buffer = buf })
  end
end

function M.patch()
  local nvdash = require "nvchad.nvdash"

  nvdash.open = function(buf, win, action)
    ensure_hls()
    action = action or "open"
    win = win or api.nvim_get_current_win()

    if not buf then
      buf = api.nvim_create_buf(false, true)
    end

    vim.g.nvdash_buf = buf
    vim.g.nvdash_win = win

    if action == "open" then
      api.nvim_win_set_buf(0, buf)
    end

    api.nvim_buf_clear_namespace(buf, rect_ns, 0, -1)

    local ui = {}
    local opts = require("nvconfig").nvdash
    opts.header = type(opts.header) == "function" and opts.header() or opts.header
    opts.buttons = type(opts.buttons) == "table" and opts.buttons or opts.buttons()

    local winh = api.nvim_win_get_height(win)
    local winw = api.nvim_win_get_width(win)

    -- header
    local nvdash_w = 0
    for _, v in ipairs(opts.header) do
      local w = strw(v)
      if w > nvdash_w then nvdash_w = w end
      local col = math.floor((winw / 2) - math.floor(strw(v) / 2)) - 6
      table.insert(ui, { virt_text_win_col = col, virt_text = { { v, "NvDashAscii" } } })
    end

    -- measure button widths
    local groups_maxw = {}
    for _, v in ipairs(opts.buttons) do
      local w
      if v.multicolumn then
        w = 0
      else
        w = strw(type(v.txt) == "string" and v.txt or v.txt() .. (v.keys or ""))
      end
      if nvdash_w < w then nvdash_w = w end
      if v.group then
        groups_maxw[v.group] = math.max(groups_maxw[v.group] or 0, w)
      end
    end

    -- render buttons
    local key_lines = {}
    local pad_w = 2

    for i, v in ipairs(opts.buttons) do
      local w = nvdash_w
      local str = type(v.txt) == "string" and v.txt or v.txt()
      if v.content == "fit" or v.group then
        w = groups_maxw[v.group] or strw(str)
      end
      str = v.rep and string.rep(str, w) or str
      str = v.keys and btn_gap(str, v.keys, w) or str

      local col = math.floor((winw / 2) - math.floor(w / 2)) - 6
      local is_active = (i == active_idx)
      local hl = is_active and "NvdashBtnRectSel" or "NvdashBtnRect"

      local str_pad = string.rep(" ", pad_w) .. str .. string.rep(" ", pad_w)
      table.insert(ui, { virt_text_win_col = col - pad_w, virt_text = { { str_pad, hl } } })

      if v.cmd then
        table.insert(key_lines, { i = #ui, cmd = v.cmd, col = col })
      end

      if not v.no_gap then
        table.insert(ui, { virt_text = { { "" } } })
      end

      if v.keys then
        map({ v.keys }, "<cmd>" .. v.cmd .. "<cr>", buf)
      end
    end

    -- keymaps section (table layout)
    local km = opts.keymaps
    if km and #km > 0 then
      table.insert(ui, { virt_text = { { "" } } })
      local hdr_txt = "Keymaps"
      local hdr_col = math.floor((winw / 2) - math.floor(strw(hdr_txt) / 2)) - 6
      local sep_txt = string.rep("─", strw(hdr_txt))
      table.insert(ui, { virt_text_win_col = hdr_col, virt_text = { { hdr_txt, "NvDashAscii" } } })
      table.insert(ui, { virt_text_win_col = hdr_col, virt_text = { { sep_txt, "NvDashAscii" } } })

      local sep_str = "  //  "
      local km_keys_max = 0
      for _, m in ipairs(km) do
        if m.keys and strw(m.keys) > km_keys_max then km_keys_max = strw(m.keys) end
      end
      local km_col = math.floor((winw / 2) - math.floor((km_keys_max + strw(sep_str) + 30) / 2)) - 6
      if km_col < 2 then km_col = 2 end
      for _, m in ipairs(km) do
        if m.category then
          table.insert(ui, { virt_text = { { "" } } })
          local cat_txt = "  " .. m.category .. "  "
          local cat_col = math.floor((winw / 2) - math.floor(strw(cat_txt) / 2)) - 6
          table.insert(ui, { virt_text_win_col = cat_col, virt_text = { { cat_txt, "NvDashHeader" } } })
        else
          local pad = string.rep(" ", km_keys_max - strw(m.keys))
          local line = m.keys .. pad .. sep_str .. m.desc
          table.insert(ui, { virt_text_win_col = km_col, virt_text = { { line, "NvDashFooter" } } })
        end
      end
    end

    -- center vertically
    local dashboard_h = #ui + 3
    winh = math.max(dashboard_h, winh)
    local row_i = math.floor((winh / 2) - (dashboard_h / 2))

    for _, v in ipairs(key_lines) do
      v.i = v.i + row_i + 1
    end

    -- fill buffer with empty lines
    vim.bo[buf].ma = true
    local empty_str = {}
    for i = 1, winh do empty_str[i] = "" end
    api.nvim_buf_set_lines(buf, 0, -1, false, empty_str)

    -- place extmarks
    for i, v in ipairs(ui) do
      api.nvim_buf_set_extmark(buf, rect_ns, row_i + i, 0, {
        virt_text = v.virt_text,
        virt_text_win_col = v.virt_text_win_col,
      })
    end

    -- find active from cursor
    local curline = fn.line ".", win
    active_idx = nil
    for i, kl in ipairs(key_lines) do
      if kl.i == curline then active_idx = i; break end
    end

    if action == "redraw" then return end

    -- keybinds
    vim.wo[win].virtualedit = "all"
    vim.wo[win].cursorline = false

    if key_lines[1] then
      api.nvim_win_set_cursor(win, { key_lines[1].i, key_lines[1].col })
      active_idx = 1
    end

    local function key_movements(n, cmd)
      local curline = fn.line "."
      for i, v in ipairs(key_lines) do
        if v.i == curline then
          local x = key_lines[i + n] or key_lines[n == 1 and 1 or #key_lines]
          if cmd and x.cmd then vim.cmd(x.cmd) else return { x.i, x.col } end
        end
      end
    end

    map({ "k", "<up>" }, function()
      local pos = key_movements(-1, false)
      if pos then api.nvim_win_set_cursor(win, pos) end
    end, buf)

    map({ "j", "<down>" }, function()
      local pos = key_movements(1, false)
      if pos then api.nvim_win_set_cursor(win, pos) end
    end, buf)

    map({ "<cr>" }, function()
      key_movements(0, true)
    end, buf)

    require("nvchad.utils").set_cleanbuf_opts("nvdash", buf)

    -- cursor tracking
    local augroup = api.nvim_create_augroup("NvdashRect", { clear = true })
    api.nvim_create_autocmd("CursorMoved", {
      group = augroup,
      buffer = buf,
      callback = function()
        local curline = fn.line ".", win
        local new_idx = nil
        for i, kl in ipairs(key_lines) do
          if kl.i == curline then new_idx = i; break end
        end
        if new_idx ~= active_idx then
          active_idx = new_idx
          require("nvchad.nvdash").open(vim.g.nvdash_buf, vim.g.nvdash_win, "redraw")
        end
      end,
    })

    api.nvim_create_autocmd({ "BufWinLeave", "BufHidden" }, {
      group = augroup,
      buffer = buf,
      callback = function()
        vim.g.nvdash_displayed = false
        pcall(api.nvim_del_augroup_by_name, "NvdashRect")
      end,
    })

    api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
      group = augroup,
      callback = function()
        local b = vim.g.nvdash_buf
        local w = vim.g.nvdash_win
        if b and w then
          vim.bo[b].ma = true
          require("nvchad.nvdash").open(b, w, "redraw")
        end
      end,
    })
  end
end

return M