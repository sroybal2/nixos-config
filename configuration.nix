{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Boot ─────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Nix store hygiene ────────────────────────────────────────────────────
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # ── Network ──────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Locale / Time ────────────────────────────────────────────────────────
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Display / Desktop ─────────────────────────────────────────────────────
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome.enable = true;

  # ── Niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Stylix — Catppuccin Mocha ──────────────────────────────────────────────
  stylix = {
    enable = true;
    polarity = "dark";

    # Solid Catppuccin base colour as wallpaper; override with an image if desired
    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } "convert -size 1920x1080 xc:'#1e1e2e' $out";

    base16Scheme = {
      scheme = "Catppuccin Mocha";
      author = "https://github.com/catppuccin/catppuccin";
      base00 = "1e1e2e"; # Base      (background)
      base01 = "181825"; # Mantle
      base02 = "313244"; # Surface0
      base03 = "45475a"; # Surface1
      base04 = "585b70"; # Surface2
      base05 = "cdd6f4"; # Text      (foreground)
      base06 = "f5c2e7"; # Rosewater
      base07 = "b4befe"; # Lavender
      base08 = "f38ba8"; # Red
      base09 = "fab387"; # Peach
      base0A = "f9e2af"; # Yellow
      base0B = "a6e3a1"; # Green
      base0C = "94e2d5"; # Teal
      base0D = "89b4fa"; # Blue
      base0E = "cba6f7"; # Mauve
      base0F = "f2cdcd"; # Flamingo
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name    = "Inter";
      };
      serif = {
        package = pkgs.inter;
        name    = "Inter";
      };
      sizes = {
        applications = 11;
        desktop      = 11;
        terminal     = 12;
      };
    };

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name    = "Adwaita";
      size    = 24;
    };

    # Qt styling via qtct is unsupported on GNOME; use adwaita Qt style instead.
    targets.qt.enable = false;
  };

  # ── Sound ─────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.steve = {
    isNormalUser = true;
    description = "Steve";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # ── System Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # GNOME extensions (system-wide so the shell can load them)
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator

    # Theming
    adw-gtk3
    papirus-icon-theme
    gnome-tweaks

    # Fonts
    inter
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji

    # Core utilities
    git
    wget
    curl
    firefox

    # oxwm companions (X11)
    alacritty
    rofi
    maim
    xclip

    # Niri / Wayland stack
    noctalia-shell
    fuzzel
    foot
    grim
    slurp
    wl-clipboard
    brightnessctl

    # Mango companion stack (referenced by ~/.config/mango/autostart.sh)
    waybar
    swaybg
    swaynotificationcenter
    wlsunset
    networkmanagerapplet
    blueman
    swayosd
    sway-audio-idle-inhibit
    wl-clip-persist
    cliphist
    fcitx5
    xdg-desktop-portal-wlr
  ];

  # ── Fonts ─────────────────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace  = [ "JetBrains Mono" ];
    };
  };

  # ── Services ──────────────────────────────────────────────────────────────
  services.xserver.windowManager.oxwm.enable = true;

  services.flatpak.enable = true;
  security.polkit.enable = true;

  system.stateVersion = "24.11";
}
