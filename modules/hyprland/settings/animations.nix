let
  # hl.curve(name, { type = "bezier", points = { { x1, y1 }, { x2, y2 } } })
  bezier = name: x1: y1: x2: y2: {
    _args = [
      name
      {
        type = "bezier";
        points = [[x1 y1] [x2 y2]];
      }
    ];
  };

  anim = leaf: speed: curve:
    {
      inherit leaf speed;
      enabled = true;
    }
    // curve;
in {
  wayland.windowManager.hyprland.settings = {
    curve = [
      (bezier "easeOutQuint" 0.23 1 0.32 1)
      (bezier "easeInOutCubic" 0.65 0.05 0.36 1)
      (bezier "linear" 0 0 1 1)
      (bezier "almostLinear" 0.5 0.5 0.75 1)
      (bezier "quick" 0.15 0 0.1 1)

      {
        _args = [
          "easy"
          {
            type = "spring";
            mass = 1;
            stiffness = 71.2633;
            dampening = 15.8273644;
          }
        ];
      }
    ];

    animation = [
      (anim "global" 10 {bezier = "default";})
      (anim "border" 5.39 {bezier = "easeOutQuint";})
      (anim "windows" 4.79 {spring = "easy";})
      (anim "windowsIn" 4.1 {
        spring = "easy";
        style = "popin 87%";
      })
      (anim "windowsOut" 1.49 {
        bezier = "linear";
        style = "popin 87%";
      })
      (anim "fadeIn" 1.73 {bezier = "almostLinear";})
      (anim "fadeOut" 1.46 {bezier = "almostLinear";})
      (anim "fade" 3.03 {bezier = "quick";})
      (anim "layers" 3.81 {bezier = "easeOutQuint";})
      (anim "layersIn" 4 {
        bezier = "easeOutQuint";
        style = "fade";
      })
      (anim "layersOut" 1.5 {
        bezier = "linear";
        style = "fade";
      })
      (anim "fadeLayersIn" 1.79 {bezier = "almostLinear";})
      (anim "fadeLayersOut" 1.39 {bezier = "almostLinear";})
      (anim "workspaces" 1.94 {
        bezier = "almostLinear";
        style = "fade";
      })
      (anim "workspacesIn" 1.21 {
        bezier = "almostLinear";
        style = "fade";
      })
      (anim "workspacesOut" 1.94 {
        bezier = "almostLinear";
        style = "fade";
      })
      (anim "zoomFactor" 7 {bezier = "quick";})
    ];
  };
}
