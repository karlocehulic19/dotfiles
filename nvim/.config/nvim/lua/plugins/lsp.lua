return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                -- Choose your preferred mode: "off", "basic", "standard", "strict", or "all"
                typeCheckingMode = "standard",
              },
            },
          },
        },
      },
    },
  },
}
