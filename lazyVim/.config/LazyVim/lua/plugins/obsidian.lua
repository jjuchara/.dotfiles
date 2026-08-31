local vault_path = vim.fs.normalize(vim.fn.expand("~/Documents/MySecondBrain"))

local function is_vault_buffer(bufnr)
  if type(bufnr) ~= "number" or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
  return path == vault_path or vim.startswith(path, vault_path .. "/")
end

local function obsidian_block_link()
  if not is_vault_buffer(0) then
    return
  end

  local link, _, range = require("obsidian.api").cursor_link()
  if not link then
    return
  end

  local location = require("obsidian.util").parse_link(link)
  if not location then
    return
  end

  local _, block = require("obsidian.util").strip_block_links(location)
  if not block then
    return
  end

  return link, require("obsidian.util").standardize_block(block), range
end

local function move_location_to_block(item, block)
  local bufnr = vim.fn.bufnr(item.filename)
  local lines

  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  else
    local ok, file_lines = pcall(vim.fn.readfile, item.filename)
    if not ok then
      return
    end
    lines = file_lines
  end

  local block_pattern = vim.pesc(block) .. "%s*$"
  for line_number, line in ipairs(lines) do
    local column = line:find(block, 1, true)
    if column and line:find(block_pattern) then
      item.lnum = line_number
      item.col = column
      item.end_lnum = line_number
      item.end_col = column + #block
      return
    end
  end
end

local function follow_block_link(link, block, range)
  require("obsidian.lsp.handlers._definition").follow_link(link, function(_, locations)
    local items = vim.lsp.util.locations_to_items(locations or {}, "utf-8")
    for _, item in ipairs(items) do
      move_location_to_block(item, block)
    end

    if #items == 1 then
      require("obsidian.api").open_note(items[1])
    elseif #items > 1 then
      Obsidian.picker.pick(items, { prompt_title = "Resolve Obsidian block link" })
    end
  end, { range = range })
end

local function goto_definition()
  local link, block, range = obsidian_block_link()
  if link then
    follow_block_link(link, block, range)
    return
  end

  Snacks.picker.lsp_definitions()
end

local publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

local function is_obsidian_block_link_diagnostic(diagnostic, bufnr)
  if not is_vault_buffer(bufnr) then
    return false
  end

  if diagnostic.source ~= "Marksman" or tostring(diagnostic.code) ~= "2" then
    return false
  end

  if not diagnostic.message:find("Link to non-existent heading", 1, true) then
    return false
  end

  local line_number = diagnostic.range and diagnostic.range.start.line
  if not line_number then
    return false
  end

  local line = vim.api.nvim_buf_get_lines(bufnr, line_number, line_number + 1, false)[1] or ""
  return line:find("%[%[[^%]]*#%^[^%]]+%]%]") ~= nil
end

local function marksman_publish_diagnostics(err, result, ctx, config)
  if result and result.diagnostics then
    local bufnr = ctx.bufnr or (result.uri and vim.uri_to_bufnr(result.uri))
    result = vim.deepcopy(result)
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      return not is_obsidian_block_link_diagnostic(diagnostic, bufnr)
    end, result.diagnostics)
  end

  return publish_diagnostics(err, result, ctx, config)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "3.16.6",
    lazy = false,
    init = function()
      vim.g.obsidian_default_keymap = false
    end,
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "MySecondBrain",
          path = "~/Documents/MySecondBrain",
        },
      },
      picker = {
        name = "snacks.picker",
      },
      completion = {
        create_new = false,
      },
      frontmatter = {
        enabled = false,
      },
      templates = {
        enabled = false,
      },
      daily_notes = {
        enabled = false,
      },
      unique_note = {
        enabled = false,
      },
      checkbox = {
        enabled = false,
        create_new = false,
      },
      slides = {
        enabled = false,
      },
      sync = {
        enabled = false,
      },
      cache = {
        enabled = false,
      },
      ui = {
        enable = false,
      },
      footer = {
        enabled = false,
      },
      statusline = {
        enabled = false,
      },
      callbacks = {
        post_setup = function()
          require("obsidian.lsp").start = function() end
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          handlers = {
            ["textDocument/publishDiagnostics"] = marksman_publish_diagnostics,
          },
          keys = {
            {
              "gd",
              goto_definition,
              desc = "Goto Markdown or Obsidian Block Definition",
              has = "definition",
            },
          },
        },
      },
    },
  },
}
