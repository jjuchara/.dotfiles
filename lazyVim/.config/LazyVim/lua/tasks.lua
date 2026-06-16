local M = {}

local VAULT = vim.fn.expand(
  "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian_jjuchara"
)
local TASKS_FILE = VAULT .. "/1. Projects/Tasks.md"
local HOME_FILE = VAULT .. "/00. Map of content/Home.md"

local NEW_TAG_OPTION = "+ новый тег..."

local function read_tags()
  local tags = {}
  local f = io.open(TASKS_FILE, "r")
  if f then
    for l in f:lines() do
      local tag = l:match("^## (#%S+)")
      if tag then
        tags[#tags + 1] = tag
      end
    end
    f:close()
  end
  tags[#tags + 1] = NEW_TAG_OPTION
  return tags
end

local function append_task(line, tag)
  local heading = "## " .. tag

  local f = io.open(TASKS_FILE, "r")
  if not f then
    vim.notify("Cannot open Tasks.md", vim.log.levels.ERROR)
    return
  end
  local lines = {}
  for l in f:lines() do
    lines[#lines + 1] = l
  end
  f:close()

  -- Find the heading and insert task at end of its section
  local insert_at = nil
  local in_section = false
  for i, l in ipairs(lines) do
    if l == heading then
      in_section = true
    elseif in_section and l:match("^## ") then
      insert_at = i - 1
      break
    elseif in_section and l:match("^%- %[") then
      insert_at = i  -- keep moving to last task line in section
    end
  end

  if in_section and insert_at == nil then
    insert_at = #lines  -- heading found, no next section → append at EOF
  end

  if insert_at then
    table.insert(lines, insert_at + 1, line)
  else
    -- Section doesn't exist — create it at end of file
    lines[#lines + 1] = ""
    lines[#lines + 1] = heading
    lines[#lines + 1] = ""
    lines[#lines + 1] = line
  end

  local out = io.open(TASKS_FILE, "w")
  if not out then
    vim.notify("Cannot write Tasks.md", vim.log.levels.ERROR)
    return
  end
  out:write(table.concat(lines, "\n") .. "\n")
  out:close()
  vim.notify("Added to " .. tag, vim.log.levels.INFO)
end

local function pick_category(callback)
  local tags = read_tags()
  vim.ui.select(tags, { prompt = "Category:" }, function(choice)
    if not choice then
      return
    end
    if choice == NEW_TAG_OPTION then
      vim.ui.input({ prompt = "New tag (without #): " }, function(input)
        if input and input ~= "" then
          local new_tag = input:match("^#") and input or ("#" .. input)
          callback(new_tag)
        end
      end)
    else
      callback(choice)
    end
  end)
end

local function pick_date(prompt, callback)
  vim.ui.input({ prompt = prompt }, function(input)
    callback(input and input ~= "" and input or nil)
  end)
end

function M.add_task()
  local today = os.date("%Y-%m-%d")
  vim.ui.input({ prompt = "📝 Задача: " }, function(name)
    if not name or name == "" then return end
    pick_category(function(tag)
      vim.ui.input({ prompt = "🛫 Дата начала [" .. today .. "]: " }, function(start_raw)
        local start_date = (start_raw and start_raw ~= "") and start_raw or today
        pick_date("📅 Дедлайн [Enter = ♾️]: ", function(due_date)
          local line = "- [ ] " .. name .. " " .. tag
            .. " ➕ " .. today
            .. " 🛫 " .. start_date
          if due_date then
            line = line .. " 📅 " .. due_date
          else
            line = line .. " ♾️"
          end
          append_task(line, tag)
        end)
      end)
    end)
  end)
end

function M.toggle_task()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  local new_line

  if line:match("^%- %[ %]") then
    local today = os.date("%Y-%m-%d")
    new_line = line:gsub("^%- %[ %]", "- [x]")
    if not new_line:match("✅") then
      new_line = new_line .. " ✅ " .. today
    end
  elseif line:match("^%- %[x%]") then
    new_line = line:gsub("^%- %[x%]", "- [ ]")
    new_line = new_line:gsub("%s*✅%s*%d%d%d%d%-%d%d%-%d%d", "")
  else
    vim.notify("Нет задачи на текущей строке", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new_line })
end

function M.open_tasks()
  vim.cmd("edit " .. vim.fn.fnameescape(TASKS_FILE))
end

-- filter: { status = "active"|"done", date = "today"|nil }
-- date="today" + status="active"  → due today    (📅 YYYY-MM-DD)
-- date="today" + status="done"    → closed today  (✅ YYYY-MM-DD)
local function collect_tasks(filter)
  local today = os.date("%Y-%m-%d")

  local sections = {}  -- tag -> [{display, lnum}]
  local order    = {}
  local cur_tag  = "ungrouped"

  local f = io.open(TASKS_FILE, "r")
  if not f then return {} end

  local lnum = 0
  for line in f:lines() do
    lnum = lnum + 1

    local htag = line:match("^## (#%S+)")
    if htag then
      cur_tag = htag
    elseif line:match("^%- %[") then
      local is_done  = line:match("^%- %[x%]") ~= nil
      local due_date = line:match("📅 (%d%d%d%d%-%d%d%-%d%d)")
      local done_date = line:match("✅ (%d%d%d%d%-%d%d%-%d%d)")

      local want_done = filter.status == "done"
      if is_done ~= want_done then goto continue end

      if filter.date == "today" then
        local cmp = want_done and done_date or due_date
        if cmp ~= today then goto continue end
      end

      if not sections[cur_tag] then
        sections[cur_tag] = {}
        order[#order + 1] = cur_tag
      end
      local display = line:gsub("^%- %[.%] ", "")
      sections[cur_tag][#sections[cur_tag] + 1] = { display = display, lnum = lnum }
    end
    ::continue::
  end
  f:close()

  -- Flatten: header entry → task entries per section
  local entries = {}
  for _, tag in ipairs(order) do
    local tasks = sections[tag]
    if #tasks > 0 then
      entries[#entries + 1] = { type = "header", display = "── " .. tag .. " ──" }
      for _, t in ipairs(tasks) do
        entries[#entries + 1] = { type = "task", display = "  " .. t.display, lnum = t.lnum }
      end
    end
  end
  return entries
end

local function show_tasks(title, filter)
  local entries = collect_tasks(filter)
  if #entries == 0 then
    vim.notify("No tasks found", vim.log.levels.INFO)
    return
  end

  vim.ui.select(entries, {
    prompt = title,
    format_item = function(e) return e.display end,
  }, function(choice)
    if not choice or choice.type == "header" then return end
    vim.cmd("edit " .. vim.fn.fnameescape(TASKS_FILE))
    vim.api.nvim_win_set_cursor(0, { choice.lnum, 0 })
  end)
end

function M.search_tasks()        show_tasks("Active tasks",         { status = "active" }) end
function M.search_done()         show_tasks("Done tasks",           { status = "done" }) end
function M.search_due_today()    show_tasks("Due today",            { status = "active", date = "today" }) end
function M.search_closed_today() show_tasks("Closed today",         { status = "done",   date = "today" }) end

local VAULT_NAME = "obsidian_jjuchara"

local function open_in_obsidian(file_path)
  -- file_path relative to vault root, URL-encoded
  local rel = file_path:gsub(VAULT .. "/", "")
  local encoded = rel:gsub(" ", "%%20"):gsub("/", "%%2F")
  local uri = "obsidian://open?vault=" .. VAULT_NAME .. "&file=" .. encoded
  vim.fn.jobstart({ "open", uri }, { detach = true })
end

function M.open_home()
  vim.fn.jobstart({ "open", "-a", "Obsidian" }, { detach = true })
end

function M.open_tasks_obsidian()
  open_in_obsidian(TASKS_FILE)
end

local map = vim.keymap.set

-- <leader>t group
map("n", "<leader>tt", M.toggle_task,         { desc = "Tasks: Toggle task" })
map("n", "<leader>ta", M.add_task,            { desc = "Tasks: Add task" })
map("n", "<leader>to", M.open_tasks,          { desc = "Tasks: Edit Tasks.md (nvim)" })
map("n", "<leader>tO", M.open_tasks_obsidian, { desc = "Tasks: Open Tasks.md in Obsidian" })
map("n", "<leader>tl", M.open_home,           { desc = "Tasks: Open Home.md in Obsidian" })

-- <leader>s group (search/tasks)
map("n", "<leader>st",  M.search_tasks,        { desc = "Tasks: active" })
map("n", "<leader>sto", M.search_tasks,        { desc = "Tasks: active (all)" })
map("n", "<leader>stc", M.search_done,         { desc = "Tasks: done (all)" })
map("n", "<leader>stO", M.search_due_today,    { desc = "Tasks: due today" })
map("n", "<leader>stC", M.search_closed_today, { desc = "Tasks: closed today" })
map("n", "<leader>sH",  M.open_home,           { desc = "Open Home (Obsidian)" })

-- Register group label for which-key
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({ { "<leader>t", group = "tasks" } })
end

return M
