{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    mouse = true;
    terminal = "tmux-256color";
    baseIndex = 1;

    extraConfig = ''
      set -ga terminal-overrides ",*:RGB"
      set -g set-clipboard on

      # split windows (opens in current directory)
      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # vim-style navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # reload config (NOT WORKING WITH NIX CONFIG)
      # unbind r
      # bind r source-file $HOME/.config/tmux/tmux.conf

      # start indexing at 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # shift + arrow keys to switch windows
      bind -n S-Left previous-window
      bind -n S-right next-window

      # alt + number to move between windows
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # -------
      # THEMING
      # -------

      thm_bg="#0b011c"
      thm_fg="#f8eddb"
      thm_cyan="#058f8f"
      thm_black="#0f1015"
      thm_gray="#3a3f5a"
      thm_teal="#55d4b2"
      thm_pink="#e1476d"
      thm_red="#c5052a"
      thm_blue="#083f84"

      # Status bar
      set -g status "on"
      set -g status-bg "''${thm_bg}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      # Messages
      set -g message-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"
      set -g message-command-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"

      # Panes
      set -g pane-border-style "fg=''${thm_gray}"
      set -g pane-active-border-style "fg=''${thm_red}"

      # Windows
      set -g window-status-activity-style "fg=''${thm_fg},bg=''${thm_bg},none"
      set -g window-status-separator ""
      set -g window-status-style "fg=''${thm_fg},bg=''${thm_bg},none"

      # Statusline - current window
      set -g window-status-current-format "#[fg=''${thm_red},bg=''${thm_bg}] #I: #[fg=''${thm_teal},bg=''${thm_bg}] \
      (✓) #[fg=''${thm_cyan},bg=''${thm_bg}] \
      #(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=''${thm_teal},bg=''${thm_bg}]"

      # Statusline - other windows
      set -g window-status-format "#[fg=''${thm_red},bg=''${thm_bg}] #I: #[fg=''${thm_fg},bg=''${thm_bg}]#W"

      # Statusline - right side
      set -g status-right "#[fg=''${thm_red},bg=''${thm_bg},nobold,nounderscore,noitalics] \
      #[fg=''${thm_bg},bg=''${thm_red},nobold,nounderscore,noitalics] \
       #[fg=''${thm_fg},bg=''${thm_gray}] #W #{?client_prefix,#[fg=''${thm_teal}],#[fg=''${thm_cyan}]}#[bg=''${thm_gray}] \
      #{?client_prefix,#[bg=''${thm_teal}],#[bg=''${thm_cyan}]}#[fg=''${thm_bg}] \
       #[fg=''${thm_fg},bg=''${thm_gray}] #S "

      # Statusline - left side (empty)
      set -g status-left ""

      # Modes
      set -g clock-mode-colour "''${thm_red}"
      set -g mode-style "fg=''${thm_red} bg=''${thm_black} bold"
    '';
  };
}