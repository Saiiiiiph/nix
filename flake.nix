{
  description = "Configuration NixOS de Saiph avec flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };  # Passe à la fois inputs et self
      modules = [
        ({ config, pkgs, ... }: {
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
