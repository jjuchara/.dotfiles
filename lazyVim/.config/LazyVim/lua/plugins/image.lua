return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      enabled = false,
    },
  },
  init = function()
    local timer = nil
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      pattern = { "*.md", "*.markdown" },
      callback = function()
        if timer then
          vim.fn.timer_stop(timer)
        end
        timer = vim.fn.timer_start(100, function()
          Snacks.image.hover()
        end)
      end,
    })
  end,
}
