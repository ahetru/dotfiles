return {
  {
    "navarasu/onedark.nvim",
    lazy = false, -- Charge le plugin immédiatement
    priority = 1000, -- Priorité élevée pour s'assurer que le thème est chargé en premier
    config = function()
      require("onedark").setup({
        style = "darker", -- Style : "dark", "darker", "cool", "deep", "warmer", "warm"
      })
      vim.cmd.colorscheme("onedark") -- Applique le thème
    end,
  },
}
