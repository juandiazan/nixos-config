{
  flake.modules.nixos.base = {
    programs.nix-ld.enable = true;
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      ripgrep
      fd
      gcc
      gnumake
      unzip
      nodejs
      lua-language-server
      tree-sitter

      nil
      alejandra
      statix
      deadnix

      neovim
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # LazyVim config, symlinked back to the working tree instead of the store:
    # lazy.nvim has to write lazy-lock.json / lazyvim.json, and edits apply
    # without a rebuild. LazyVim installs itself and the plugins on first start.
    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/modules/base/programs/neovim/nvim";
  };
}
