local M = {}

local job_id = nil
local PORT = 8080

M.port = PORT
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
    if vim.fn.filereadable(cur .. "/index.html") == 1 then
      return cur, true
    end
    local parent = vim.fn.fnamemodify(cur, ":h")
    if parent == cur then
      return dir, false
    end
    cur = parent
  end
end

local function clean_stale()
  vim.fn.system "pkill -f '[l]ive-server'"
  vim.fn.system "sleep 0.4"
end

function M.stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end
  M.root = nil
  M.url = nil
  vim.fn.system "pkill -f '[l]ive-server'"
  vim.cmd.redrawstatus()
  vim.notify "LiveServer: OFF"
end

function M.toggle()
  if job_id then
    M.stop()
    return
  end

  local bin = vim.fn.exepath "live-server"
  if bin == "" then
    vim.notify("live-server no está en PATH (npm i -g live-server)", vim.log.levels.ERROR)
    return
  end

  local file = current_file()
  local base_dir = vim.fn.getcwd()
  if file ~= "" and vim.fn.filereadable(file) == 1 then
    base_dir = vim.fn.fnamemodify(file, ":h")
  end

  local root, has_index = find_root(base_dir)
  clean_stale()

  M.root = root
  job_id = vim.fn.jobstart({
    bin,
    "--port=" .. PORT,
    "--wait=100",
    "--no-browser",
    ".",
  }, {
    cwd = root,
    detach = true,
    on_exit = function()
      job_id = nil
      M.root = nil
      M.url = nil
      vim.cmd.redrawstatus()
    end,
  })

  if job_id == 0 then
    job_id = nil
    M.root = nil
    M.url = nil
    vim.notify("no se pudo iniciar live-server", vim.log.levels.ERROR)
    return
  end

  M.url = "http://localhost:" .. PORT .. "/"
  if not has_index then
    local name = vim.fn.fnamemodify(file, ":t")
    if name:match("%.tex$") then
      name = name:gsub("%.tex$", ".pdf")
    end
    M.url = M.url .. name
  end
  vim.cmd.redrawstatus()
  vim.notify "LiveServer: ON"
end

function M.open()
  if not job_id then
    vim.notify("LiveServer: apagado — prende con <leader>ls", vim.log.levels.WARN)
    return
  end
  vim.ui.open(M.url)
end

vim.keymap.set("n", "<leader>ls", M.toggle, { desc = "toggle live server" })
vim.keymap.set("n", "<leader>lS", M.open, { desc = "open live server in browser" })

return M
