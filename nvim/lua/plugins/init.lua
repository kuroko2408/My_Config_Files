return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local conf = require "nvchad.configs.nvimtree"
      conf.view.width = 38 -- wider file tree (default was 30)
      return conf
    end,
  },
}
