local function format_json(content, sort)
  local args = sort and { "jq", "--sort-keys", "." } or { "jq", "." }
  local result = vim.system(args, { stdin = content }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout), nil
  end
  local py_args = sort
      and { "python3", "-c", "import json,sys; print(json.dumps(json.load(sys.stdin),indent=2,sort_keys=True))" }
    or { "python3", "-m", "json.tool" }
  local py_result = vim.system(py_args, { stdin = content }):wait()
  if py_result.code == 0 then
    return vim.trim(py_result.stdout), nil
  end
  return nil, vim.trim(py_result.stderr ~= "" and py_result.stderr or result.stderr or "Invalid JSON")
end

local function minify_json(content)
  local result = vim.system({ "jq", "-c", "." }, { stdin = content }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout), nil
  end
  local py_result = vim.system(
    { "python3", "-c", "import json,sys; print(json.dumps(json.load(sys.stdin),separators=(',',':')))" },
    { stdin = content }
  ):wait()
  if py_result.code == 0 then
    return vim.trim(py_result.stdout), nil
  end
  return nil, vim.trim(py_result.stderr ~= "" and py_result.stderr or result.stderr or "Invalid JSON")
end

local function open_json_scratchpad()
  local left_buf = vim.api.nvim_create_buf(false, true)
  local right_buf = vim.api.nvim_create_buf(false, true)
  for _, b in ipairs({ left_buf, right_buf }) do
    vim.bo[b].filetype = "json"
    vim.bo[b].bufhidden = "wipe"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local half = math.floor(width / 2)

  local left_win = vim.api.nvim_open_win(left_buf, true, {
    relative = "editor",
    width = half - 1,
    height = height - 2,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Input ",
    title_pos = "center",
    footer = " jf:format  jm:minify  jk:sort  jy:copy  Tab:switch  q:close ",
    footer_pos = "center",
  })
  vim.wo[left_win].wrap = true
  vim.wo[left_win].cursorline = true
  vim.wo[left_win].number = true

  local right_win = vim.api.nvim_open_win(right_buf, false, {
    relative = "editor",
    width = half - 1,
    height = height - 2,
    col = col + half + 1,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Output ",
    title_pos = "center",
  })
  vim.wo[right_win].wrap = false
  vim.wo[right_win].cursorline = true
  vim.wo[right_win].number = true

  local timer = vim.uv.new_timer()
  local closed = false

  local function close()
    if closed then return end
    closed = true
    timer:stop()
    timer:close()
    for _, w in ipairs({ left_win, right_win }) do
      if vim.api.nvim_win_is_valid(w) then
        vim.api.nvim_win_close(w, true)
      end
    end
  end

  local function buf_content(buf)
    return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  end

  local function buf_set(buf, text)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  end

  local function run_transform(fn, label)
    local content = buf_content(left_buf)
    if vim.trim(content) == "" then
      vim.notify("Nothing to " .. label, vim.log.levels.WARN)
      return
    end
    local out, err = fn(content)
    if err then
      vim.notify("JSON error:\n" .. err, vim.log.levels.ERROR)
      return
    end
    buf_set(right_buf, out)
  end

  local function copy_current()
    local text = buf_content(vim.api.nvim_get_current_buf())
    if vim.trim(text) == "" then
      vim.notify("Buffer is empty", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg("+", text)
    vim.notify("Copied to clipboard", vim.log.levels.INFO)
  end

  local function toggle_pane()
    local target = vim.api.nvim_get_current_win() == left_win and right_win or left_win
    if vim.api.nvim_win_is_valid(target) then
      vim.api.nvim_set_current_win(target)
    end
  end

  -- debounced auto-format: left input → right output
  local suppress_auto = false

  local function auto_format_input()
    if suppress_auto then return end
    timer:stop()
    timer:start(300, 0, vim.schedule_wrap(function()
      if closed or not vim.api.nvim_buf_is_valid(left_buf) or not vim.api.nvim_buf_is_valid(right_buf) then
        return
      end
      local content = buf_content(left_buf)
      if vim.trim(content) == "" then
        buf_set(right_buf, "")
        return
      end
      local formatted, _ = format_json(content, false)
      if formatted then
        buf_set(right_buf, formatted)
      end
      -- silently ignore errors while typing
    end))
  end

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = left_buf,
    callback = auto_format_input,
  })

  -- keymaps
  for _, buf in ipairs({ left_buf, right_buf }) do
    local opts = { buffer = buf, nowait = true }
    vim.keymap.set("n", "q", close, opts)
    vim.keymap.set("n", "<leader>jf", function() run_transform(function(c) return format_json(c, false) end, "format") end, opts)
    vim.keymap.set("n", "<leader>jm", function() run_transform(minify_json, "minify") end, opts)
    vim.keymap.set("n", "<leader>jk", function() run_transform(function(c) return format_json(c, true) end, "sort") end, opts)
    vim.keymap.set("n", "<leader>jy", copy_current, opts)
    vim.keymap.set("n", "<Tab>", toggle_pane, opts)
  end

  -- clean up both windows if either closes
  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if tonumber(ev.match) == left_win or tonumber(ev.match) == right_win then
        close()
        return true
      end
    end,
  })

  -- auto-paste from clipboard on open
  local clip = vim.fn.getreg("+")
  if clip and vim.trim(clip) ~= "" then
    local trimmed = vim.trim(clip)
    if trimmed:match("^[{%[]") then
      suppress_auto = true
      buf_set(left_buf, trimmed)
      suppress_auto = false
      local formatted, _ = format_json(trimmed, false)
      if formatted then
        buf_set(right_buf, formatted)
      end
    end
  end

  vim.cmd("startinsert")
end

return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>js",
        open_json_scratchpad,
        desc = "JSON Scratchpad",
      },
    },
  },
}
