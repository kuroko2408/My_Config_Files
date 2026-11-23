require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- escape from insert mode using jj (and jk)
map("i", "jj", "<ESC>", { desc = "Escape to normal mode" })
map("i", "jk", "<ESC>", { desc = "Escape to normal mode" })

-- smart delete word in normal mode (handles cursor on word OR on whitespace)
local function delete_word_normal()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")

  if #line == 0 then
    return
  end

  local char = line:sub(col, col)
  if char == "" or char:match("%s") then
    local prefix = line:sub(1, col)
    if prefix:match("%S") then
      vim.cmd('normal! b"zdaw')
    else
      vim.cmd('normal! "zd^')
    end
  else
    vim.cmd('normal! "zdaw')
  end
end

-- smart delete word in insert mode (deletes whole word when on a letter, or backward when at end/space)
local function delete_word_insert()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local char_at = line:sub(col, col)

  if char_at ~= "" and not char_at:match("%s") then
    -- Cursor is on a word letter: delete the whole word and remain in insert mode
    return vim.keycode('<C-o>"zdaw')
  else
    -- Cursor is at end of word or on whitespace: delete word backward
    return vim.keycode("<C-w>")
  end
end

-- delete word with Ctrl + Backspace in normal & visual mode
map({ "n", "v" }, "<C-BS>", delete_word_normal, { desc = "Delete word" })
map({ "n", "v" }, "<C-h>", delete_word_normal, { desc = "Delete word" })

-- delete word with Ctrl + Backspace in insert & command mode
map("i", "<C-BS>", delete_word_insert, { expr = true, desc = "Delete word in insert mode" })
map("i", "<C-h>", delete_word_insert, { expr = true, desc = "Delete word in insert mode" })
map("c", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
map("c", "<C-h>", "<C-w>", { desc = "Delete word backward" })

-- helper to get listed buffers
local function get_buffers()
  if vim.t.bufs and #vim.t.bufs > 0 then
    return vim.t.bufs
  end
  local bufs = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.api.nvim_buf_is_loaded(b) then
      table.insert(bufs, b)
    end
  end
  return bufs
end

-- switch tabs/buffers with Alt + 1..0 (matching Kitty)
for i = 1, 9 do
  map({ "n", "t" }, string.format("<A-%s>", i), function()
    local bufs = get_buffers()
    if bufs and bufs[i] then
      vim.api.nvim_set_current_buf(bufs[i])
    elseif vim.fn.tabpagenr("$") >= i then
      vim.cmd(i .. "tabnext")
    end
  end, { desc = "Go to tab " .. i })
end

map({ "n", "t" }, "<A-0>", function()
  local bufs = get_buffers()
  if bufs and bufs[10] then
    vim.api.nvim_set_current_buf(bufs[10])
  elseif vim.fn.tabpagenr("$") >= 10 then
    vim.cmd("10tabnext")
  end
end, { desc = "Go to tab 10" })
