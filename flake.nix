{
  description = "Configuration NixOS de Saiph avec flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Utilisation de la branche unstable
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";  # Change si tu es sur ARM (aarch64-linux)
        modules = [ ./configuration.nix ];
      };
    };
  };
}
