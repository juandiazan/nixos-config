{ config, pkgs, ... }:
{
  programs.zsh = {
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
       alias ls='eza -lh --group-directories-first --icons=auto'
       alias lsa='ls -a'
       alias lt='eza --tree --level=2 --long --icons --git'
       alias lta='lt -a'
      fi
      fastfetch
    '';
  };
}
