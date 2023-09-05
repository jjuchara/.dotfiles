return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity/motion/nvim-surround/" },
  { import = "astrocommunity/pack/go" },
  { import = "astrocommunity/pack/typescript" },
  { import = "astrocommunity/pack/python" },
  { import = "astrocommunity/pack/docker" },
  { import = "astrocommunity/pack/bash" },
  { import = "astrocommunity/pack/lua" },
  { import = "astrocommunity/pack/markdown" },
  { import = "astrocommunity/pack/tailwindcss" },
  { import = "astrocommunity/pack/toml" },
  { import = "astrocommunity/pack/yaml" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
}
