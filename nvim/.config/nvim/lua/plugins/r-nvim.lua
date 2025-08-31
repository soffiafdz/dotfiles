-- R.nvim
return {
  "R-nvim/R.nvim",
  opts = function(_, opts)
    opts.R_app = "radian" -- Use radian

    -- Open data.frames with vd
    table.insert(opts.view_df, { open_app = "terminal:vd" })

    -- Conditional adjustments for TMUX
    local tmux = os.getenv("TMUX") ~= nil
    if tmux then
      opts.config_tmux = true
      opts.external_term = "tmux split-window -hf"
      table.insert(opts.view_df, { open_app = "tmux new-window 80 vd" })
    end

    return opts
  end,
}
