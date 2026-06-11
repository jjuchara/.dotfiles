-- return {
--   "stevearc/conform.nvim",
--   dependencies = { "mason.nvim" },
--   lazy = true,
--   cmd = "ConformInfo",
--   opts = {
--     formatters_by_ft = {
--       css = { "prettier" },
--       html = { "prettier" },
--       tsx = { "conform" },
--       javascript = { "conform" },
--       javascriptreact = { "conform" },
--       typescript = { "conform" },
--       typescriptreact = { "conform" },
--     },
--   },
-- }

return {
  "stevearc/conform.nvim",
  optional = true,
  ---@param opts ConformOpts
  opts = function(_, opts)
    -- Определяем поддерживаемые типы файлов
    local supported = {
      "tsx",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
    }
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    for _, ft in ipairs(supported) do
      opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      table.insert(opts.formatters_by_ft[ft], "biome")
    end
    opts.formatters = opts.formatters or {}
    opts.formatters.biome = {
      require_cwd = true,
    }
  end,
}
