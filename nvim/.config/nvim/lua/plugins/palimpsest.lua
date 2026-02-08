-- Local Palimpsest project integration
-- Check multiple possible locations (varies by machine)
local possible_paths = {
  vim.fn.expand("~/Developer/palimpsest"),
  vim.fn.expand("~/Repos/palimpsest"),
  vim.fn.expand("~/Documents/palimpsest"),
}

local palimpsest_path = nil
for _, path in ipairs(possible_paths) do
  if vim.fn.isdirectory(path .. "/dev") == 1 then
    palimpsest_path = path
    break
  end
end

if palimpsest_path then
  return {
    {
      "palimpsest/local",
      name = "palimpsest.nvim",
      dir = palimpsest_path .. "/dev",
      dependencies = { "vimwiki/vimwiki" },
      config = function()
        require("palimpsest").setup()
      end,
    },
  }
else
  return {}
end
