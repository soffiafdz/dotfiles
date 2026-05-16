local function get_wordcount()
  local word_count = 0

  if vim.fn.mode():find("[vV]") then
    word_count = vim.fn.wordcount().visual_words
  else
    word_count = vim.fn.wordcount().words
  end

  return word_count
end

local function wordcount()
  local label = "word"
  local word_count = get_wordcount()

  if word_count > 1 then
    label = label .. "s"
  end

  return word_count .. " " .. label
end

local function is_prose()
  return vim.bo.filetype == "markdown"
    or vim.bo.filetype == "text"
    or vim.bo.filetype == "vimwiki"
end

local function clock()
  return os.date("%R")
end

local function is_not_prose()
  return not is_prose()
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          { wordcount, cond = is_prose },
          { clock, cond = is_not_prose },
        },
      },
    },
  },
}
