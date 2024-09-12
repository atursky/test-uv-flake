{
  description = "Python development environment with uv and direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python312      # Use the specific version of Python you need
            uv             # For virtual environment management
            gcc            # Add GCC for compiling dependencies
            zlib
            stdenv.cc.cc.lib
            jupyter
            python312Packages.jupyter_client
            python312Packages.pyzmq
          ];

          shellHook = ''
            # Create a virtual environment if it doesn't exist
            if [ ! -d ".venv" ]; then
              uv venv .venv
            fi
            source .venv/bin/activate

            # Alias pip to use uv for improved performance
            alias pip="uv pip"
            echo "uv pip environment ready"
          '';
        };
      }
    );
}