{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = "[](color_red_main)$os$username[](bg:color_cyan fg:color_red_main)$directory[](fg:color_cyan bg:color_teal)$git_branch$git_status[](fg:color_teal bg:color_magenta)$c$cpp$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:color_magenta bg:color_bg3)$docker_context$conda$pixi[](fg:color_bg3 bg:color_bg1)$time[ ](fg:color_bg1)$line_break$character";

      palette = "custom";

      palettes.custom = {
        color_teal = "#55d4b2";
        color_cyan = "#058f8f";
        color_red_main = "#c5052a";
        color_magenta = "#704bb6";
        color_black = "#0b011c";
        color_white = "#f8eddb";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
      };

      os = {
        disabled = false;
        style = "bg:color_red_main fg:color_teal";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          AOSC = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
          CachyOS = "󰣇 ";
          NixOS = " ";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:color_red_main fg:color_white";
        style_root = "bg:color_red_main fg:color_white";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:color_white bg:color_cyan";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
          "dotfiles" = " ";
        };
      };

      git_branch = {
      symbol = "";
        style = "bg:color_teal";
        format = "[[ $symbol $branch ](fg:color_black bg:color_teal)]($style)";
      };

      git_status = {
        style = "bg:color_teal";
        format = "[[($all_status$ahead_behind )](fg:color_black bg:color_teal)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      cpp = {
        symbol = " ";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      java = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:color_magenta";
        format = "[[ $symbol( $version) ](fg:color_white bg:color_magenta)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = "[[ $symbol( $context) ](fg:color_white bg:color_bg3)]($style)";
      };

      conda = {
        style = "bg:color_bg3";
        format = "[[ $symbol( $environment) ](fg:color_white bg:color_bg3)]($style)";
      };

      pixi = {
        style = "bg:color_bg3";
        format = "[[ $symbol( $version)( $environment) ](fg:color_white bg:color_bg3)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_bg1";
        format = "[[  $time ](fg:color_white bg:color_bg1)]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_teal)";
        error_symbol = "[](bold fg:color_red_main)";
        vimcmd_symbol = "[](bold fg:color_teal)";
        vimcmd_replace_one_symbol = "[](bold fg:color_magenta)";
        vimcmd_replace_symbol = "[](bold fg:color_magenta)";
        vimcmd_visual_symbol = "[](bold fg:color_white)";
      };
    };
  };
}

