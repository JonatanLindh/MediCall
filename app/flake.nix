{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };

        androidSdk = (pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "33.0.1" "28.0.3" "34.0.0" ];
          platformVersions = [ "33" "34" "35" ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
        }).androidsdk;

      in
      {
        devShell = with pkgs; mkShell rec {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

          buildInputs = [
            flutter327
            androidSdk
            jdk17
            gtk3
            glib
            pkg-config
          ];
        };
      }
    );
}
