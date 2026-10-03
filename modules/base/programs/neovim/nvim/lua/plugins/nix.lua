-- nil/alejandra are provided by the nixos-config flake (home.packages in
-- modules/base/programs/neovim/neovim.nix) and already on PATH, so use those instead of
-- LazyVim's defaults (mason-built nil_ls, nixfmt).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {
          mason = false,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
  },
}
