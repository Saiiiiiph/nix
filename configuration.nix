{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nom de la machine
  networking.hostName = "nixos";

  # Wireguard
  networking.firewall.checkReversePath = false;

  # Activer le réseau
  networking.networkmanager.enable = true;

  # Configuration du fuseau horaire
  time.timeZone = "Europe/Paris";

  # Configuration de la localisation
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Activer le serveur X11
  services.xserver.enable = true;

  # Activer KDE Plasma 6
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configuration du clavier
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console.keyMap = "fr";

  # Activer l'impression
  services.printing.enable = true;

  # Configuration du son avec PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Création de l'utilisateur "saiph"
  users.users.saiph = {
    isNormalUser = true;
    description = "saiph";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      spotify
      discord
      filezilla
      git
      stable.vscode  # Maintenant disponible via l'overlay
    ];
  };

  # Connexion automatique de l'utilisateur
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "saiph";

  # Installer Firefox
  programs.firefox.enable = true;

  # Installer Steam
  programs.steam.enable = true;

  # Autoriser les paquets non libres
  nixpkgs.config.allowUnfree = true;

  # Ajouter des paquets globaux si besoin
  environment.systemPackages = with pkgs; [
    # vim  # Décommente si tu veux ajouter Vim
    # wget
  ];

  # Activer les flakes et Nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Version de l'état du système (ne pas modifier après installation)
  system.stateVersion = "24.11";

}
