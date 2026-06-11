return {
  "akinsho/bufferline.nvim",
  config = function()
    local bufferline = require("bufferline")
    local highlights = {}

    -- Детальная диагностика
    print("Checking catppuccin integration...")

    local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
    if catppuccin_ok then
      print("Catppuccin loaded successfully")

      local integration_ok, integration = pcall(require, "catppuccin.groups.integrations.bufferline")
      if integration_ok then
        print("Bufferline integration found")

        if integration.get then
          print("Using integration.get()")
          highlights = integration.get()
        elseif integration.get_theme then
          print("Using integration.get_theme()")
          highlights = integration.get_theme()
        else
          print("No get method found")
        end
      else
        print("Bufferline integration not found")
      end
    else
      print("Catppuccin not loaded")
    end

    bufferline.setup({
      highlights = highlights,
    })
  end,
}
