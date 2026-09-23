local M = {}

local job_id = nil

M.port = nil
M.root = nil
M.url = nil

function M.is_running()
  return job_id ~= nil
end

local function current_file()
  return vim.fn.expand "%:p"
end

local function find_root(dir)
  local cur = vim.fn.fnamemodify(dir, ":p")
  while true do
    if vim.fn.filereadable(cur .. "/package.json") == 1 then
      return cur
    end
    local parent = vim.fn.fnamemodify(cur, ":h")
    if parent == cur then
      return dir
    end
    cur = parent
  end
end

local function clean_stale()
  vim.fn.system "pkill -f '[n]pm run dev'"
  vim.fn.system "sleep 0.4"
end

function M.stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end
  M.root = nil
  M.url = nil
  M.port = nil
  vim.fn.system "pkill -f '[n]pm run dev'"
  vim.cmd.redrawstatus()
  vim.notify "NPM dev: OFF"
end

function M.toggle()
  if job_id then
    M.stop()
    return
  end

  local bin = vim.fn.exepath "npm"
  if bin == "" then
    vim.notify("npm no está en PATH", vim.log.levels.ERROR)
    return
  end

  local file = current_file()
  local base_dir = vim.fn.getcwd()
  if file ~= "" and vim.fn.filereadable(file) == 1 then
    base_dir = vim.fn.fnamemodify(file, ":h")
  end

  local root = find_root(base_dir)
  clean_stale()

  M.root = root
  job_id = vim.fn.jobstart({
    "sh",
    "-c",
    "exec npm run dev",
  }, {
    cwd = root,
    detach = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          line = line:gsub("\r", "")
          local url = line:match("https?://[%w%.%-:%/]+")
          if url then
            url = url:gsub("/?$", "")
            M.url = url
            M.port = url:match(":(%d+)$")
            vim.cmd.redrawstatus()
            vim.notify("NPM dev: " .. url)
          end
        end
      end
    end,
    on_exit = function()
      job_id = nil
      M.root = nil
      M.url = nil
      M.port = nil
      vim.cmd.redrawstatus()
    end,
  })

  if job_id == 0 then
    job_id = nil
    M.root = nil
    M.url = nil
    M.port = nil
    vim.notify("no se pudo iniciar npm run dev", vim.log.levels.ERROR)
    return
  end

  vim.cmd.redrawstatus()
  vim.notify "NPM dev: ON"
end

function M.open()
  if not job_id then
    vim.notify("NPM dev: apagado — prende con <leader>nd", vim.log.levels.WARN)
    return
  end
  if not M.url then
    vim.notify("NPM dev: esperando el puerto del servidor...", vim.log.levels.WARN)
    return
  end
  vim.ui.open(M.url)
end

vim.keymap.set("n", "<leader>nd", M.toggle, { desc = "toggle npm run dev" })
vim.keymap.set("n", "<leader>nD", M.open, { desc = "open npm dev server in browser" })

return M