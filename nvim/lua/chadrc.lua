-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,

  changed_themes = {
    catppuccin = {
      base_16 = {
        base00 = "#000000", -- pure black base
        base01 = "#0d0d0d",
        base02 = "#181818",
        base03 = "#262626",
      },
      base_30 = {
        black = "#000000",
        darker_black = "#000000",
        black2 = "#0a0a0a",
        one_bg = "#121212",
        one_bg2 = "#1a1a1a",
        one_bg3 = "#242424",
        statusline_bg = "#0d0d0d",
        lightbg = "#181818",
        line = "#1e1e1e",
        red = "#ed333b", -- katana crimson
      },
    },
  },

  hl_override = {
    Normal = { bg = "NONE" },
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    LineNr = { bg = "NONE" },
    NvimTreeNormal = { bg = "NONE" },
    NvimTreeNormalNC = { bg = "NONE" },
    NvimTreeWinSeparator = { fg = "#1e1e1e", bg = "NONE" },
    TbLineBufOn = { bg = "#1c1c1c", fg = "#ffffff", bold = true },
    TbLineBufOff = { bg = "NONE", fg = "#888888" },
    TblineFill = { bg = "NONE" },
    StatusLine = { bg = "#0d0d0d" },
  },
}

M.ui = {
  tabufline = {
    enabled = true,
    lazyload = false,
  },
}

return M
