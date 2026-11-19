-- glosa editor plugin: loaded only where a glosa checkout exists
-- (~/Developer on macOS, ~/Repos on Linux); nothing elsewhere.
local possible_paths = {
  vim.fn.expand("~/Developer/glosa"),
  vim.fn.expand("~/Repos/glosa"),
}

local glosa_path = nil
for _, path in ipairs(possible_paths) do
  if vim.fn.isdirectory(path .. "/editor/nvim") == 1 then
    glosa_path = path
    break
  end
end

if glosa_path then
  return {
    {
      dir = glosa_path .. "/editor/nvim",
      name = "glosa",
      lazy = false,
      -- <leader>n while the old palimpsest plugin still owns <leader>p (<leader>g is git);
      -- drop this line at the switch to take the <leader>p layout.
      opts = { keymaps = { prefix = "<leader>n" } },
    },
  }
else
  return {}
end
