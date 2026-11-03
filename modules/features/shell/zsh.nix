{
  flake.modules.nixos.shell = {pkgs, ...}: {
    programs.zsh.enable = true;

    users.users.juani.shell = pkgs.zsh;
  };

  flake.modules.homeManager.shell.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "obraun";
      plugins = [
        "aliases"
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
       alias ls='eza'
       alias lt='eza --tree --level=2'
      fi
      fastfetch
    '';
  };
}
