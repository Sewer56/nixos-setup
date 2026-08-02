-- Theme colors - substituted from the Nix theme system by home-manager
local accent = "@accent@"
local accent2 = "@accent2@"
local inactive = "@inactive@"

hl.config({
  general = {
    gaps_in = 5;
    gaps_out = 0;
    border_size = 2;
    col = {
      active_border = { colors = { accent, accent2 }, angle = 45 };
      inactive_border = inactive;
    };
  };

  decoration = {
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/ for more
    rounding = 10;
    blur = { enabled = true; };
  };

  animations = {
    enabled = true;
  };
})

-- Some default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- hyprpicker provides the screenshot freeze overlay; disable only its layer animation.
hl.layer_rule({
  match = { namespace = "hyprpicker" };
  no_anim = true;
})

-- Window transparency rules
hl.window_rule({ match = { class = "^(Alacritty)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(org.wezfurlong.wezterm)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(code)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(code-url-handler)$" }, opacity = "0.9 0.9" })
-- opacity 0.9 0.9, match:class ^(jetbrains-rider)$ -- Does not blur, so disabled for now.
hl.window_rule({ match = { class = "^(thunar)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(org.gnome.Nautilus)$" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(dolphin)$" }, opacity = "0.9 0.9" })
