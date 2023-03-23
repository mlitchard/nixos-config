{ self, inputs, config, ... }:
let
  mkHomeModule = name: extraModules: {
    users.users.${name}.isNormalUser = true;
    home-manager.users.${name} = {
      imports = [
        self.homeModules.common-linux
        ../home/git.nix
      ] ++ extraModules;
    };
  };
in
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      myself = mkHomeModule config.people.myself [
        ../home/shellcommon.nix
      ];
      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.myself
        inputs.agenix.nixosModule
        ./caches
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
      ];
    };
  };
}
