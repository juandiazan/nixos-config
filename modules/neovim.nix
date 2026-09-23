{pkgs, ...}: {
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

  # xdg.configFile."nvim" = {
  #   source = ./dotfiles/nvim;
  #   recursive = true;
  # };
}
