{
  flake.modules.nixos.base = {pkgs, ...}: {
    programs.zsh.enable = true;

    users.users.juani.shell = pkgs.zsh;
  };

  flake.modules.homeManager.base.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "obraun";
      plugins = [
        "aliases"
        "alias-finder"
        "command-not-found"
        "colored-man-pages"
        "git"
        "cabal"
        "dotnet"
        "docker"
        "docker-compose"
        "poetry"
        "vscode"
        "nestjs"
        "direnv"
      ];
    };

    initContent = ''
      zstyle 'omz:plugins:alias-finder' autoload yes
      zstyle 'omz:plugins:alias-finder' longer yes
      zstyle 'omz:plugins:alias-finder' exact yes
      zstyle 'omz:plugins:alias-finder' cheaper yes
      if command -v bat &> /dev/null; then
       alias cat='bat'
      fi
      if command -v eza &> /dev/null; then
       alias ls='eza'
       alias lt='eza --tree --level=2'
       alias lta='lt -a'
      fi
      fastfetch
    '';
  };
}
