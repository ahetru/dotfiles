return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        auto_show = false,
      },
      ghost_text = {
        enabled = false, -- 💥 désactive le texte gris
      },
    },

    sources = {
      default = { "lsp", "path", "buffer" },
    },
  },
}
