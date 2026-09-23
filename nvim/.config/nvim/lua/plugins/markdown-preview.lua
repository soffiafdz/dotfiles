local css = vim.fn.stdpath("config") .. "/markdown-preview.css"

-- Serve the preview on the Tailscale interface so it can be opened from
-- another machine on the tailnet; without Tailscale, keep the plugin's
-- default local-browser behaviour.
local function tailscale_ip()
  if vim.fn.executable("tailscale") == 0 then
    return nil
  end
  local ip = vim.trim(vim.fn.system({ "tailscale", "ip", "-4" }))
  if vim.v.shell_error ~= 0 or ip == "" then
    return nil
  end
  return ip
end

-- Called by the plugin instead of launching a browser. Keeps the URL
-- around, puts it on the clipboard (OSC 52 carries it over SSH), and
-- prints it. `:MkdpUrl` repeats this at any time.
local function announce(url)
  vim.g.mkdp_last_url = url
  pcall(vim.fn.setreg, "+", url)
  vim.api.nvim_echo({ { "Preview: ", "Title" }, { url, "Underlined" }, { "  (copied; :MkdpUrl to show again)", "Comment" } }, true, {})
end

return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_markdown_css = css
      vim.g.mkdp_port = "8765"
      local ip = tailscale_ip()
      if ip then
        vim.g.mkdp_open_to_the_world = 1
        vim.g.mkdp_open_ip = ip
        -- The page is opened by hand, so leaving the buffer must not
        -- close it (the plugin would otherwise close it on BufHidden).
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_echo_preview_url = 0
        _G.MkdpAnnounce = announce
        vim.cmd([[
          function! MkdpNoBrowser(url)
            call v:lua.MkdpAnnounce(a:url)
          endfunction
        ]])
        vim.g.mkdp_browserfunc = "MkdpNoBrowser"
      else
        vim.g.mkdp_echo_preview_url = 1
      end
      vim.api.nvim_create_user_command("MkdpUrl", function()
        if vim.g.mkdp_last_url then
          announce(vim.g.mkdp_last_url)
        else
          vim.notify("No preview running. :MarkdownPreview first.", vim.log.levels.WARN)
        end
      end, {})
    end,
  },
}
