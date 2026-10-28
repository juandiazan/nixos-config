{
  flake.modules.homeManager.shell.home.shellAliases = {
    cls = "clear";
    lzg = "lazygit";
    rip = "abcde";
    v = "nvim";

    enc = "tmux new-session -A -s nixos-config -c ~/nixos-config nvim .";
    dei = "devenv init";
    dea = "devenv allow";

    ti = "terraform init";
    tf = "terraform fmt";
    tv = "terraform validate";
    tp = "terraform plan";
    ta = "terraform apply";
    td = "terraform destroy";

    "ls-status" = "~/nixos-config/scripts/network/localsend-toggle.sh status";
    "ls-on" = "~/nixos-config/scripts/network/localsend-toggle.sh on";
    "ls-off" = "~/nixos-config/scripts/network/localsend-toggle.sh off";

    ".." = "cd ..";
  };
}
