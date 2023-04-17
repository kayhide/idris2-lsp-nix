{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      overlay = final: prev: { };

      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };
          idris2-lsp = with pkgs; callPackage ./nix/idris2-lsp { };
        in
        {
          packages.default = idris2-lsp;
          apps.default = {
            type = "app";
            program = "${idris2-lsp}/bin/idris2-lsp";
          };
        };
    in

    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
