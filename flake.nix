{
  description = "Configuration NixOS de Saiph avec flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, lib, ... }: {
          # Définir nixpkgs-stable comme overlay pour pouvoir l'utiliser partout
          nixpkgs.overlays = [
            (final: prev: {
              stable = import nixpkgs-stable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            })
          ];
        })
        ./configuration.nix
      ];
    };
  };
}
