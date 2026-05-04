{ config, pkgs, lib, ... }:

let
  inherit (lib.hm.gvariant) mkUint32 mkInt32 mkDouble mkTuple mkVariant;
in {
  home.username = "steve";
  home.homeDirectory = "/home/steve";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Adopt new home-manager default; Stylix manages GTK4 CSS directly.
  gtk.gtk4.theme = null;

  # Override Stylix's "qtct" default — adwaita is correct for a GNOME session.
  qt.platformTheme.name = lib.mkForce "adwaita";

  # ── dconf / GNOME settings ────────────────────────────────────────────────
  # Stylix manages: color-scheme, gtk-theme, cursor-theme, all font entries.
  # We only set settings that Stylix does not touch.
  dconf.settings = {

    "org/gnome/shell" = {
      enabled-extensions = [
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "firefox.desktop"
        "org.gnome.TextEditor.desktop"
      ];
      disable-overview-on-startup = true;
    };

    "org/gnome/desktop/interface" = {
      icon-theme              = "Papirus-Dark";
      accent-color            = "blue";
      show-battery-percentage = true;
      enable-hot-corners      = false;
      clock-show-seconds      = false;
      clock-show-weekday      = true;
    };

    # background and screensaver are owned by Stylix's GNOME target

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
      focus-mode = "click";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces         = false;
      workspaces-only-on-primary = true;
      edge-tiling                = false;
    };

    # ── Pop Shell ─────────────────────────────────────────────────────────
    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default           = true;
      active-hint               = true;
      active-hint-border-radius = mkUint32 10;
      gap-inner                 = mkUint32 6;
      gap-outer                 = mkUint32 6;
      show-title                = false;
      smart-gaps                = true;
    };

    # ── Dash to Dock ──────────────────────────────────────────────────────
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position                = "BOTTOM";
      dock-fixed                   = false;
      autohide                     = true;
      autohide-in-fullscreen       = true;
      intellihide                  = true;
      intellihide-mode             = "FOCUS_APPLICATION_WINDOWS";
      extend-height                = false;
      custom-theme-shrink          = true;
      dash-max-icon-size           = mkInt32 48;
      show-mounts                  = false;
      show-trash                   = false;
      show-apps-at-top             = false;
      show-show-apps-button        = true;
      transparency-mode            = "FIXED";
      background-opacity           = mkDouble 0.85;
      click-action                 = "focus-or-previews";
      scroll-action                = "cycle-windows";
      running-indicator-style      = "DOTS";
      disable-overview-on-startup  = true;
      apply-custom-theme           = false;
    };

    # ── Blur my Shell ─────────────────────────────────────────────────────
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = mkDouble 0.75;
      sigma      = 14;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur                = true;
      brightness          = mkDouble 0.6;
      sigma               = 15;
      override-background = true;
      unblur-in-overview  = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur       = true;
      brightness = mkDouble 0.6;
      sigma      = 15;
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur       = true;
      brightness = mkDouble 0.6;
      sigma      = 15;
    };

    # ── Just Perfection ───────────────────────────────────────────────────
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button              = false;
      app-menu                       = false;
      panel-size                     = 32;
      clock-menu-position            = 1;
      clock-menu-position-offset     = 0;
      workspace-switcher-should-show = false;
      notification-banner-position   = 2;
      window-demands-attention-focus = true;
    };

    # ── Keyboard shortcuts ────────────────────────────────────────────────
    "org/gnome/desktop/wm/keybindings" = {
      close                 = [ "<Super>w" ];
      maximize              = [ "<Super>Up" ];
      unmaximize            = [ "<Super>Down" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      move-to-workspace-1   = [ "<Shift><Super>1" ];
      move-to-workspace-2   = [ "<Shift><Super>2" ];
      move-to-workspace-3   = [ "<Shift><Super>3" ];
      move-to-workspace-4   = [ "<Shift><Super>4" ];
      switch-windows        = [ "<Alt>Tab" ];
      switch-applications   = [ "<Super>Tab" ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ "<Super>slash" ];
      toggle-overview         = [ "<Super>grave" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      home     = [ "<Super>e" ];
      www      = [ "<Super>b" ];
      terminal = [ "<Super>t" ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click                 = true;
      natural-scroll               = true;
      two-finger-scrolling-enabled = true;
    };
  };

  # ── Niri ──────────────────────────────────────────────────────────────────
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 200
            repeat-rate 25
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.2
        }
        mouse {
            accel-speed 0.0
        }
    }

    layout {
        gaps 8
        center-focused-column "never"

        preset-column-widths {
            proportion 0.333333
            proportion 0.5
            proportion 0.666667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "#89b4fa"
            inactive-color "#45475a"
        }

        border {
            off
        }
    }

    spawn-at-startup "noctalia-shell"

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

    animations { slowdown 1.0; }

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    window-rule {
        match app-id="org.gnome.Calculator"
        open-floating true
        default-column-width { fixed 480; }
    }

    binds {
        // Applications
        Mod+Return { spawn "foot"; }
        Mod+T      { spawn "foot"; }
        Mod+D      { spawn "fuzzel"; }
        Mod+E      { spawn "nautilus"; }
        Mod+B      { spawn "firefox"; }

        // Screenshot (niri built-in)
        Print       { screenshot; }
        Shift+Print { screenshot-screen; }
        Alt+Print   { screenshot-window; }

        // Audio
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        // Brightness
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

        // Window management
        Mod+Q { close-window; }

        // Focus — arrow keys and vim keys
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        // Move
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+J { move-window-down; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+L { move-column-right; }

        // Column first/last
        Mod+Home       { focus-column-first; }
        Mod+End        { focus-column-last; }
        Mod+Shift+Home { move-column-to-first; }
        Mod+Shift+End  { move-column-to-last; }

        // Monitor focus
        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }

        // Move column to monitor
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

        // Workspace switching
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+U         { focus-workspace-down; }
        Mod+I         { focus-workspace-up; }

        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Column sizing
        Mod+R       { switch-preset-column-width; }
        Mod+Minus   { set-column-width "-10%"; }
        Mod+Equal   { set-column-width "+10%"; }
        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C       { center-column; }

        // Column grouping
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Session
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        Mod+Shift+R { spawn "niri" "msg" "action" "load-config-file"; }
    }
  '';

  # ── Foot terminal ─────────────────────────────────────────────────────────
  # Stylix handles colours; we set font and behaviour only.
  programs.foot = {
    enable = true;
    settings = {
      main  = { font = "JetBrainsMono Nerd Font Mono:size=12"; };
      mouse = { hide-when-typing = "yes"; };
    };
  };

  # ── Fuzzel launcher ───────────────────────────────────────────────────────
  # Stylix handles colours.
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font          = "Inter:size=11";
        border-radius = 8;
        width         = 40;
        lines         = 10;
      };
    };
  };

  # ── Shell ──────────────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    initExtra = ''
      nr() {
        sudo nixos-rebuild switch --flake /home/steve#default && \
        git -C /home/steve add -A && \
        git -C /home/steve commit -m "auto: nixos rebuild $(date '+%Y-%m-%d %H:%M')" && \
        git -C /home/steve push
      }
    '';
  };

  # ── User packages ─────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    obsidian
    mc
    nixd
  ];

  programs.helix = {
    enable = true;
    languages = {
      language-server.nixd = {
        command = "nixd";
      };
      language = [{
        name = "nix";
        language-servers = [ "nixd" ];
      }];
    };
  };

  # ── oxwm configuration (X11 only — no conflict with niri) ────────────────
  xdg.configFile."oxwm/config.lua".text = ''
    ---@meta
    ---@module 'oxwm'

    local modkey  = "Mod4"
    local terminal = "alacritty"

    local colors = {
        fg         = "#bbbbbb",
        red        = "#f7768e",
        bg         = "#1a1b26",
        cyan       = "#0db9d7",
        green      = "#9ece6a",
        lavender   = "#a9b1d6",
        light_blue = "#7aa2f7",
        grey       = "#bbbbbb",
        blue       = "#6dade3",
        purple     = "#ad8ee6",
        sep        = "#444b6a",
    }

    local tags = { "", "󰊯", "", "", "󰙯", "󱇤", "", "󱘶", "󰧮" }

    local bar_font = "JetBrainsMono Nerd Font Propo:style=Bold:size=12"

    local blocks = {
        oxwm.bar.block.shell({
            format   = " {}",
            command  = "uname -r",
            interval = 999999999,
            color    = colors.red,
            underline = true,
        }),
        oxwm.bar.block.static({
            text     = " │  ",
            interval = 999999999,
            color    = colors.sep,
            underline = false,
        }),
        oxwm.bar.block.ram({
            format   = "󰍛 Ram: {used}/{total} GB",
            interval = 5,
            color    = colors.light_blue,
            underline = true,
        }),
        oxwm.bar.block.static({
            text     = " │  ",
            interval = 999999999,
            color    = colors.sep,
            underline = false,
        }),
        oxwm.bar.block.datetime({
            format      = "󰸘 {}",
            date_format = "%a, %b %d - %-I:%M %P",
            interval    = 1,
            color       = colors.cyan,
            underline   = true,
        }),
    }

    oxwm.set_terminal(terminal)
    oxwm.set_modkey(modkey)
    oxwm.set_tags(tags)

    oxwm.set_layout_symbol("tiling", "[T]")
    oxwm.set_layout_symbol("normie", "[F]")
    oxwm.set_layout_symbol("tabbed", "[=]")

    oxwm.border.set_width(2)
    oxwm.border.set_focused_color(colors.blue)
    oxwm.border.set_unfocused_color(colors.grey)

    oxwm.gaps.set_smart(false)
    oxwm.gaps.set_inner(6, 6)
    oxwm.gaps.set_outer(6, 6)

    oxwm.rule.add({ instance = "gimp",    floating = true })
    oxwm.rule.add({ class    = "firefox", tag = 3 })

    oxwm.bar.set_font(bar_font)
    oxwm.bar.set_blocks(blocks)
    oxwm.bar.set_scheme_normal(colors.fg,   colors.bg, "#444444")
    oxwm.bar.set_scheme_occupied(colors.cyan, colors.bg, colors.cyan)
    oxwm.bar.set_scheme_selected(colors.cyan, colors.bg, colors.purple)

    -- Applications
    oxwm.key.bind({ modkey },           "Return", oxwm.spawn_terminal())
    oxwm.key.bind({ modkey },           "D",      oxwm.spawn({ "sh", "-c", "rofi -show drun" }))
    oxwm.key.bind({ modkey },           "S",      oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" }))
    oxwm.key.bind({ modkey },           "Q",      oxwm.client.kill())

    -- Window state
    oxwm.key.bind({ modkey, "Shift" },  "Slash",  oxwm.show_keybinds())
    oxwm.key.bind({ modkey, "Shift" },  "F",      oxwm.client.toggle_fullscreen())
    oxwm.key.bind({ modkey, "Shift" },  "Space",  oxwm.client.toggle_floating())

    -- Layouts
    oxwm.key.bind({ modkey },           "C",      oxwm.layout.set("tiling"))
    oxwm.key.bind({ modkey },           "N",      oxwm.layout.cycle())
    oxwm.key.bind({ modkey },           "H",      oxwm.set_master_factor(-5))
    oxwm.key.bind({ modkey },           "L",      oxwm.set_master_factor(5))
    oxwm.key.bind({ modkey },           "I",      oxwm.inc_num_master(1))
    oxwm.key.bind({ modkey },           "P",      oxwm.inc_num_master(-1))
    oxwm.key.bind({ modkey },           "A",      oxwm.toggle_gaps())
    oxwm.key.bind({ modkey },           "B",      oxwm.toggle_bar())

    -- WM controls
    oxwm.key.bind({ modkey, "Shift" },  "Q",      oxwm.quit())
    oxwm.key.bind({ modkey, "Shift" },  "R",      oxwm.restart())

    -- Focus / stack
    oxwm.key.bind({ modkey },           "J",      oxwm.client.focus_stack(1))
    oxwm.key.bind({ modkey },           "K",      oxwm.client.focus_stack(-1))
    oxwm.key.bind({ modkey, "Shift" },  "J",      oxwm.client.move_stack(1))
    oxwm.key.bind({ modkey, "Shift" },  "K",      oxwm.client.move_stack(-1))

    -- Multi-monitor
    oxwm.key.bind({ modkey },           "Comma",  oxwm.monitor.focus(-1))
    oxwm.key.bind({ modkey },           "Period", oxwm.monitor.focus(1))
    oxwm.key.bind({ modkey, "Shift" },  "Comma",  oxwm.monitor.tag(-1))
    oxwm.key.bind({ modkey, "Shift" },  "Period", oxwm.monitor.tag(1))

    -- Tag navigation
    oxwm.key.bind({ modkey }, "1", oxwm.tag.view(0))
    oxwm.key.bind({ modkey }, "2", oxwm.tag.view(1))
    oxwm.key.bind({ modkey }, "3", oxwm.tag.view(2))
    oxwm.key.bind({ modkey }, "4", oxwm.tag.view(3))
    oxwm.key.bind({ modkey }, "5", oxwm.tag.view(4))
    oxwm.key.bind({ modkey }, "6", oxwm.tag.view(5))
    oxwm.key.bind({ modkey }, "7", oxwm.tag.view(6))
    oxwm.key.bind({ modkey }, "8", oxwm.tag.view(7))
    oxwm.key.bind({ modkey }, "9", oxwm.tag.view(8))

    oxwm.key.bind({ modkey, "Shift" }, "1", oxwm.tag.move_to(0))
    oxwm.key.bind({ modkey, "Shift" }, "2", oxwm.tag.move_to(1))
    oxwm.key.bind({ modkey, "Shift" }, "3", oxwm.tag.move_to(2))
    oxwm.key.bind({ modkey, "Shift" }, "4", oxwm.tag.move_to(3))
    oxwm.key.bind({ modkey, "Shift" }, "5", oxwm.tag.move_to(4))
    oxwm.key.bind({ modkey, "Shift" }, "6", oxwm.tag.move_to(5))
    oxwm.key.bind({ modkey, "Shift" }, "7", oxwm.tag.move_to(6))
    oxwm.key.bind({ modkey, "Shift" }, "8", oxwm.tag.move_to(7))
    oxwm.key.bind({ modkey, "Shift" }, "9", oxwm.tag.move_to(8))

    oxwm.key.bind({ modkey, "Control" }, "1", oxwm.tag.toggleview(0))
    oxwm.key.bind({ modkey, "Control" }, "2", oxwm.tag.toggleview(1))
    oxwm.key.bind({ modkey, "Control" }, "3", oxwm.tag.toggleview(2))
    oxwm.key.bind({ modkey, "Control" }, "4", oxwm.tag.toggleview(3))
    oxwm.key.bind({ modkey, "Control" }, "5", oxwm.tag.toggleview(4))
    oxwm.key.bind({ modkey, "Control" }, "6", oxwm.tag.toggleview(5))
    oxwm.key.bind({ modkey, "Control" }, "7", oxwm.tag.toggleview(6))
    oxwm.key.bind({ modkey, "Control" }, "8", oxwm.tag.toggleview(7))
    oxwm.key.bind({ modkey, "Control" }, "9", oxwm.tag.toggleview(8))

    oxwm.key.bind({ modkey, "Control", "Shift" }, "1", oxwm.tag.toggletag(0))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "2", oxwm.tag.toggletag(1))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "3", oxwm.tag.toggletag(2))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "4", oxwm.tag.toggletag(3))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "5", oxwm.tag.toggletag(4))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "6", oxwm.tag.toggletag(5))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "7", oxwm.tag.toggletag(6))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "8", oxwm.tag.toggletag(7))
    oxwm.key.bind({ modkey, "Control", "Shift" }, "9", oxwm.tag.toggletag(8))

    -- Keychord: Mod+Space then T → spawn terminal
    oxwm.key.chord({
        { { modkey }, "Space" },
        { {},         "T" }
    }, oxwm.spawn_terminal())
  '';
}
