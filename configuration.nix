{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Nom de la machine
  networking.hostName = "nixos";
  networking.firewall.checkReversePath = false;
  networking.networkmanager.enable = true;
  # Fuseau horaire et localisation
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "fr_FR.UTF-8";
  };
  # Activer le serveur X11 et KDE Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Clavier
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";
  # Impression
  services.printing.enable = true;
  # Son avec PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Ajout du support Bluetooth pour PipeWire
    wireplumber.enable = true;
  };
  
  # Configuration Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  
  # Ajouter l'applet Bluetooth pour KDE
  environment.systemPackages = with pkgs; [
    mangohud
    protonup
    steam-run
    vulkan-tools
    kdePackages.bluedevil  # Applet Bluetooth pour KDE Plasma
    bluez-tools  # Outils en ligne de commande pour le Bluetooth
    kdePackages.plasma-pa  # Pour l'intégration audio Bluetooth dans KDE
  ];
  
  # OpenGL & Vulkan optimisé
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk # Pilote Vulkan AMD optimisé
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      libva
      libvdpau
    ];
  };
  # Optimisation CPU
  powerManagement.cpuFreqGovernor = "performance";
  systemd.services.turbo-boost.enable = false;
  # Optimisation pour le gaming
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  environment.variables = {
    MANGOHUD = "1";
    RADV_PERFTEST = "aco";
    VK_ICD_FILENAMES = "/run/opengl-driver/etc/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/etc/vulkan/icd.d/radeon_icd.i686.json";
    VK_LAYER_PATH = "/run/opengl-driver/etc/vulkan/explicit_layer.d:/run/opengl-driver-32/etc/vulkan/explicit_layer.d";
  };
  # Utilisateur
  users.users.saiph = {
    isNormalUser = true;
    description = "saiph";
    extraGroups = [ "networkmanager" "wheel" "audio" "bluetooth" ];  # Ajout du groupe bluetooth
    packages = with pkgs; [
      spotify
      discord
      filezilla
      git
      vscode
      firefox
      brave
      (vivaldi.overrideAttrs (old: {
        dontWrapQtApps = false;
        dontPatchELF = true;
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          kdePackages.wrapQtAppsHook
        ];
      }))
    ];
  };
  # Connexion automatique
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "saiph";
  # Steam & Proton
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  # Autoriser les paquets non libres
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "steam" "steam-unwrapped" ];
  
  # Activer les flakes et Nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Version de l'état du système
  system.stateVersion = "24.11";
}