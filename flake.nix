{
  description = "NWS Alerts custom component development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          python313Packages.pip
          python313Packages.venvShellHook
          ruff
        ];

        venvDir = ".venv";

        postVenvCreation = ''
          pip install -r requirements_test.txt
        '';
      };
    };
}
