{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      #extraSpecialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
         home-manager.nixosModules.home-manager
      ];
      specialArgs = {inherit inputs; };
    };
  };
}
