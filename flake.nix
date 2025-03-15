{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-precommit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nix-precommit-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        pre-commit-check = nix-precommit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            statix.enable = true;
          };
        };
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit (pre-commit-check) shellHook;
            buildInputs = with pkgs; [
              zig
              watchexec
            ];
          };
        };
      }
    );
}
