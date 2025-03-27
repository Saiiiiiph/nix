{
  description = "Configuration NixOS de Saiph avec flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Branche unstable pour le système
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";  # Branche stable pour VS Code
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            environment.systemPackages = [
              (import nixpkgs-stable { system = "x86_64-linux"; }).vscode
            ];
          })
          (import ./configuration.nix { inherit inputs; })  # <-- Passer `inputs` ici
        ];
      };
    };
  };
}
