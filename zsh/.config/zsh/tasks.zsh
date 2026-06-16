_TASKS_FILE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian_jjuchara/1. Projects/Tasks.md"

# fzf date picker — возвращает YYYY-MM-DD или пустую строку (Esc = пропустить)
# usage: _pick_date "prompt label" [allow_skip]
_pick_date() {
  local label="$1"
  local allow_skip="${2:-0}"

  local header="↑↓ выбор  /  поиск: mon jun today  /  Esc = "
  [[ "$allow_skip" == "1" ]] && header+="пропустить (♾️)" || header+="отмена"

  python3 << 'PYEOF' | fzf --ansi --no-sort \
    --delimiter=$'\t' --with-nth=2.. \
    --prompt="$label " \
    --header="$header" \
    --height=12 --layout=reverse --border \
    | cut -f1
from datetime import date, timedelta
import sys

today = date.today()
DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
MONTHS = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

for i in range(90):
    d = today + timedelta(days=i)
    iso   = d.strftime("%Y-%m-%d")
    wday  = DAYS[d.weekday()]
    month = MONTHS[d.month - 1]
    day   = str(d.day).rjust(2)
    year  = d.year

    suffix = ""
    if i == 0:   suffix = "  \033[90m← today\033[0m"
    elif i == 1: suffix = "  \033[90m← tomorrow\033[0m"

    if d.weekday() >= 5:
        display = f"\033[90m{wday}  {day} {month} {year}{suffix}\033[0m"
    else:
        display = f"{wday}  {day} {month} {year}{suffix}"

    print(f"{iso}\t{display}")
PYEOF
}

# Просмотр задач с тоглом по пробелу, открытие в Obsidian по Enter
tv() {
  export _TV_FILE="$_TASKS_FILE"
  local tmp=$(mktemp -d)

  cat > "$tmp/list.py" << 'PYEOF'
import sys, re, os

tasks = {}
order = []
current_tag = None

with open(os.environ["_TV_FILE"]) as f:
    lines = f.readlines()

for i, raw in enumerate(lines, 1):
    line = raw.rstrip()
    m = re.match(r'^## (#\S+)', line)
    if m:
        current_tag = m.group(1)
        if current_tag not in tasks:
            tasks[current_tag] = {"active": [], "done": []}
            order.append(current_tag)
    elif current_tag:
        if re.match(r'^- \[ \]', line):
            tasks[current_tag]["active"].append((i, line[6:]))
        elif re.match(r'^- \[x\]', line):
            tasks[current_tag]["done"].append((i, line[6:]))

for tag in order:
    g = tasks[tag]
    if not g["active"] and not g["done"]:
        continue
    print(f"0\t\033[33m── {tag} ──\033[0m")
    for lineno, t in g["active"]:
        print(f"{lineno}\t  \033[32m○\033[0m  {t}")
    for lineno, t in g["done"]:
        print(f"{lineno}\t  \033[90m✓  {t}\033[0m")
PYEOF

  cat > "$tmp/toggle.py" << 'PYEOF'
import sys, re, os

try:
    lineno = int(sys.argv[1]) - 1
except (IndexError, ValueError):
    sys.exit(0)

if lineno < 0:
    sys.exit(0)

with open(os.environ["_TV_FILE"]) as f:
    lines = f.readlines()

if lineno >= len(lines):
    sys.exit(0)

line = lines[lineno]
if re.match(r'^- \[ \]', line):
    lines[lineno] = line.replace("- [ ]", "- [x]", 1)
elif re.match(r'^- \[x\]', line):
    lines[lineno] = line.replace("- [x]", "- [ ]", 1)

with open(os.environ["_TV_FILE"], "w") as f:
    f.writelines(lines)
PYEOF

  python3 "$tmp/list.py" | fzf --ansi --no-sort \
    --delimiter=$'\t' --with-nth=2.. \
    --prompt="Tasks > " \
    --bind "space:execute-silent(python3 $tmp/toggle.py {1})+reload(python3 $tmp/list.py)" \
    --bind "enter:execute(open -a Obsidian)+abort"

  rm -rf "$tmp"
}

# Добавить задачу — аналог <leader>ta в LazyVim
ta() {
  local today="$(date +%Y-%m-%d)"

  # Название через gum (красивый input с placeholder)
  local name
  name=$(gum input --placeholder "Название задачи..." --prompt "📝 ")
  [[ -z "$name" ]] && echo "Отменено" && return 1

  # Тег из файла + новый
  local existing_tags
  existing_tags=$(grep -E '^## #' "$_TASKS_FILE" | sed 's/^## //')

  local tag
  tag=$(printf "%s\n+ новый тег..." "$existing_tags" | fzf \
    --prompt="🏷  Тег > " \
    --height=12 --layout=reverse --border)
  [[ -z "$tag" ]] && echo "Отменено" && return 1

  if [[ "$tag" == "+ новый тег..." ]]; then
    local raw_tag
    raw_tag=$(gum input --placeholder "new-tag (без #)" --prompt "🆕 ")
    [[ -z "$raw_tag" ]] && echo "Отменено" && return 1
    tag="#${raw_tag#\#}"
  fi

  # Дата начала — fzf calendar (Enter на today = берёт сегодня)
  local start_date
  start_date=$(_pick_date "🛫 Дата начала >")
  [[ -z "$start_date" ]] && echo "Отменено" && return 1

  # Дедлайн — fzf calendar (Esc = ♾️)
  local due_date
  due_date=$(_pick_date "📅 Дедлайн >" 1)

  # Собираем строку
  local line="- [ ] ${name} ${tag} ➕ ${today} 🛫 ${start_date}"
  [[ -n "$due_date" ]] && line="${line} 📅 ${due_date}" || line="${line} ♾️"

  export _TA_FILE="$_TASKS_FILE"
  export _TA_HEADING="## ${tag}"
  export _TA_LINE="$line"

  python3 << 'PYEOF'
import os

tasks_file = os.environ["_TA_FILE"]
heading    = os.environ["_TA_HEADING"]
new_line   = os.environ["_TA_LINE"]

with open(tasks_file) as f:
    lines = f.readlines()

in_section = False
insert_at  = None

for i, l in enumerate(lines):
    s = l.rstrip()
    if s == heading:
        in_section = True
    elif in_section and s.startswith("## "):
        break
    elif in_section and s.startswith("- ["):
        insert_at = i

if in_section:
    pos = (insert_at + 1) if insert_at is not None else next(
        (i + 1 for i, l in enumerate(lines) if l.rstrip() == heading),
        len(lines),
    )
    lines.insert(pos, new_line + "\n")
else:
    lines += ["\n", heading + "\n", "\n", new_line + "\n"]

with open(tasks_file, "w") as f:
    f.writelines(lines)
PYEOF

  echo "✓ $line"
}
