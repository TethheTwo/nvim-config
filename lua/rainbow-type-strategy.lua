local lib = require "rainbow-delimiters.lib"
local util = require "rainbow-delimiters.util"
local log = require "rainbow-delimiters.log"

local Stack = require "rainbow-delimiters.stack"
local MatchTree = require "rainbow-delimiters.match-tree"

local TYPE_OFFSET = {
  ["("] = 0,
  [")"] = 0,
  ["["] = 1,
  ["]"] = 1,
  ["{"] = 2,
  ["}"] = 2,
  ["<"] = 3,
  [">"] = 3,
}

local function normalize_change(change)
  local result
  if #change == 4 then
    result = change
  elseif #change == 6 then
    result = { change[1], change[2], change[4], change[5] }
  else
    result = {}
  end
  return result
end

local function highlight(tree, bufnr, lang, level)
  for delimiter in tree.match.delimiters:items() do
    local text = vim.treesitter.get_node_text(delimiter, bufnr)
    local offset = TYPE_OFFSET[text] or 0
    lib.highlight(bufnr, lang, delimiter, lib.hlgroup_at(level + offset))
  end
  for child in tree.children:items() do
    highlight(child, bufnr, lang, level + 1)
  end
end

local function update_range(bufnr, changes, tree, lang)
  log.debug("Updated range with changes %s", vim.inspect(changes))

  if not lib.enabled_for(lang) or vim.fn.pumvisible() ~= 0 then
    return
  end

  local query = lib.get_query(lang, bufnr)
  if not query then
    return
  end

  local root_node = tree:root()

  for _, change in ipairs(changes) do
    local match_trees = Stack.new()
    local start_row, end_row = change[1], change[3] + 1
    lib.clear_namespace(bufnr, lang, start_row, end_row)

    for _, match in query:iter_matches(root_node, bufnr, start_row, end_row) do
      local this = MatchTree.assemble(query, match)
      while match_trees:size() > 0 do
        local other = match_trees:pop()
        if this < other then
          this(other)
        else
          match_trees:push(other)
          break
        end
      end
      match_trees:push(this)
    end
    for _, match_tree in match_trees:iter() do
      highlight(match_tree, bufnr, lang, 1)
    end
  end
end

local function full_update(bufnr, parser)
  log.debug("Performing full updated on buffer %d", bufnr)
  local function callback(tree, sub_parser)
    local changes = { { tree:root():range() } }
    update_range(bufnr, changes, tree, sub_parser:lang())
  end

  parser:for_each_tree(callback)
end

local function setup_parser(bufnr, parser, start_parent_lang)
  log.debug("Setting up parser for buffer %d", bufnr)

  local function f(p, lang, parent_lang)
    log.debug("Setting up parser for '%s' in buffer %d", lang, bufnr)
    if not lib.get_query(lang, bufnr) then
      return
    end

    local function on_changedtree(changes, tree)
      log.trace("Changed tree in buffer %d with languages %s", bufnr, lang)
      if not lib.buffers[bufnr] then
        return
      end

      if not parent_lang then
        changes = vim.tbl_map(normalize_change, changes)
      elseif parent_lang ~= lang and changes[1] then
        changes = { { tree:root():range() } }
      else
        changes = {}
      end

      if changes[1] then
        update_range(bufnr, changes, tree, lang)
      end
    end

    local function on_child_added(child)
      setup_parser(bufnr, child, lang)
    end

    p:register_cbs {
      on_changedtree = on_changedtree,
      on_child_added = on_child_added,
    }
    log.trace("Done with setting up parser for '%s' in buffer %d", lang, bufnr)
  end

  util.for_each_child(start_parent_lang, parser:lang(), parser, f)

  full_update(bufnr, parser)
end

local function on_attach(bufnr, settings)
  log.trace("rainbow-type-strategy on_attach for buffer %d", bufnr)
  local parser = settings.parser
  setup_parser(bufnr, parser, nil)
end

local function on_detach(bufnr)
  log.trace("rainbow-type-strategy on_detach for buffer %d", bufnr)
end

local function on_reset(bufnr, settings)
  log.trace("rainbow-type-strategy on_reset for buffer %d", bufnr)
  full_update(bufnr, settings.parser)
end

return {
  on_attach = on_attach,
  on_detach = on_detach,
  on_reset = on_reset,
}
