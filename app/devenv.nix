{ pkgs, lib, config, inputs, ... }:
let
  android-sdk = inputs.android.sdk.${pkgs.stdenv.system} (sdk: with sdk; [
    cmdline-tools-latest
    platform-tools
    build-tools-34-0-0
    build-tools-35-0-0
    build-tools-36-0-0 # Referenced in GRADLE_OPTS
    platforms-android-34
    platforms-android-35
    ndk-26-3-11579264
  ]);
  originalFlutter = pkgs.flutter; # Renamed for clarity
  flutterMod = "${config.devenv.state}/flutter";

  flutterInstall = ''
    set -e # Exit immediately if a command exits with a non-zero status.
    target="${flutterMod}"
    source="${originalFlutter}"

    echo "Source Flutter SDK: $source"
    echo "Target modifiable Flutter SDK: $target"

    # Check if already correctly installed (basic check: .git dir and .flutter-wrapped link)
    if [ -d "$target/.git" ] && [ -L "$target/bin/flutter" ] && [ "$(readlink "$target/bin/flutter")" = "$target/bin/.flutter-wrapped" ]; then
      # Optional: Add a version check here if you want to auto-update on pkgs.flutter change
      echo "Flutter SDK already installed and patched in $target."
      exit 0
    fi

    echo "Cleaning up old target directory $target (if any)..."
    rm -rf "$target"
    mkdir -p "$target"

    echo "Copying Flutter SDK from $source to $target using rsync..."
    # Use rsync to copy everything, including .git and hidden files.
    # The trailing slash on source means "copy the contents of source".
    rsync -a --checksum "$source/" "$target/"
    # --checksum is more robust than just timestamp/size for verifying if files need updating,
    # though for a clean copy like this, -a is often enough.

    echo "Setting permissions for $target..."
    chmod u+wX -R "$target"

    echo "Patching Flutter SDK in $target..."
    if [ ! -f "$target/bin/.flutter-wrapped" ]; then
        echo "ERROR: $target/bin/.flutter-wrapped not found after rsync. Original SDK might be structured differently than expected."
        exit 1
    fi
    rm -f "$target/bin/flutter" # Remove original flutter executable/symlink
    ln -s "$target/bin/.flutter-wrapped" "$target/bin/flutter"

    # Link Dart SDK
    # The original pkgs.flutter/bin/dart is usually a symlink to bin/cache/dart-sdk/bin/dart
    # We want our flutterMod/bin/dart to point to where the original one pointed, resolved.
    if [ ! -L "${originalFlutter}/bin/dart" ]; then
        echo "Warning: Original ${originalFlutter}/bin/dart is not a symlink. Linking directly."
        ln -sf "$(readlink -f "${originalFlutter}/bin/dart")" "$target/bin/dart"
    else
        # This assumes the dart sdk is correctly copied under $target/bin/cache/dart-sdk
        # Let's rather ensure the symlink points within our $target structure if possible,
        # or to the original NIX store path for dart if the copy is faithful.
        # The safest is to replicate the symlink structure Flutter expects.
        # Flutter itself, when FLUTTER_ROOT is set, should find its Dart SDK under $FLUTTER_ROOT/bin/cache/dart-sdk/
        # So, the dart symlink in $FLUTTER_ROOT/bin should ideally point there.
        # The rsync should have copied $source/bin/cache/dart-sdk correctly.
        # The .flutter-wrapped script usually sets up paths to use the Dart SDK inside FLUTTER_ROOT.
        # So, we might not even need to manually link $target/bin/dart if .flutter-wrapped handles it.
        # However, the original nix derivation does: ln -s cache/dart-sdk/bin/dart bin/dart within its build.
        # Rsync should preserve this relative symlink. Let's verify.
        if [ -L "$target/bin/dart" ] && [ "$(readlink "$target/bin/dart")" = "cache/dart-sdk/bin/dart" ]; then
            echo "Dart symlink $target/bin/dart -> cache/dart-sdk/bin/dart seems correct."
        else
            echo "Re-creating dart symlink in $target/bin to point to its internal cache..."
            rm -f "$target/bin/dart"
            ln -s "cache/dart-sdk/bin/dart" "$target/bin/dart"
        fi
        # Also ensure the actual Dart SDK is present
        if [ ! -f "$target/bin/cache/dart-sdk/bin/dart" ]; then
            echo "ERROR: Dart SDK executable not found at $target/bin/cache/dart-sdk/bin/dart after rsync."
            # This would indicate a problem with the source Flutter package or rsync.
        fi
    fi


    # Final verification
    if [ ! -d "$target/.git" ]; then
      echo "CRITICAL ERROR: $target/.git directory is MISSING after rsync!"
      exit 1
    else
      echo ".git directory found in $target."
    fi
    echo "Flutter SDK installation and patching in $target complete."
  '';
in
{
  dotenv.enable = true;

  packages = [
    android-sdk
    originalFlutter # Keep original for the install script
    pkgs.git
    pkgs.rsync # ***** ADDED/ENSURED *****
  ];

  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk17;
    gradle.enable = true;
  };

  env = rec {
    ANDROID_HOME = "${android-sdk}/libexec/android-sdk";
    ANDROID_AVD_HOME = "${config.devenv.state}/.android/avd";
    ANDROID_USER_HOME = "${config.devenv.state}/.android";
    FLUTTER_ROOT = flutterMod; # Points to the modifiable copy
    # PATH needs to ensure that $FLUTTER_ROOT/bin is primary for flutter and dart
    # devenv typically adds package binaries to PATH.
    # We need to ensure our $FLUTTER_ROOT/bin and its dart-sdk take precedence.
    # Prepending to the PATH is a common strategy.
    PATH = lib.mkForce [
      "${FLUTTER_ROOT}/bin"
      "${FLUTTER_ROOT}/bin/cache/dart-sdk/bin" # For Dart executable itself
      # The existing PATH constructed by devenv will be appended by default if not using mkForce
      # If you want to append to the existing PATH:
      # PATH = "${FLUTTER_ROOT}/bin:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin:" + lib.strings.makeBinPath [ /* other devenv packages */ ];
      # However, devenv manages PATH well. The key is FLUTTER_ROOT being set.
      # Let's rely on FLUTTER_ROOT and ensure git is found from pkgs.git.
      # The default devenv PATH setup should be sufficient if FLUTTER_ROOT is correctly used by flutter tools.
    ];
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/36.0.0/aapt2";
  };

  tasks."flutter-sdk:install".exec = flutterInstall;

  # Optional: A task to verify the setup
  tasks."flutter:verify" = {
    exec = ''
      echo "FLUTTER_ROOT=$FLUTTER_ROOT"
      echo "PATH=$PATH"
      echo "which flutter: $(which flutter)"
      echo "which dart: $(which dart)"
      echo "which git: $(which git)"
      if [ -d "$FLUTTER_ROOT/.git" ]; then
        echo "FLUTTER_ROOT/.git directory exists."
        (cd "$FLUTTER_ROOT" && git --version && git -c log.showSignature=false log -n 1 --pretty=format:%H) || echo "Git command failed in FLUTTER_ROOT"
      else
        echo "ERROR: FLUTTER_ROOT/.git directory DOES NOT EXIST."
      fi
      echo "Running flutter doctor -v"
      flutter doctor -v
    '';
    # dependsOn = [ "flutter-sdk:install" ]; # If devenv supports task dependencies
  };


  enterShell = ''
    # Accept Android SDK licenses
    if [ -d "${android-sdk}/cmdline-tools/latest/bin" ]; then # newer structure
      yes | ${android-sdk}/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null || true
    elif [ -d "${android-sdk}/tools/bin" ]; then # older structure, just in case
      yes | ${android-sdk}/tools/bin/sdkmanager --licenses > /dev/null || true
    fi

    # Check if Flutter SDK needs installation
    # This basic check ensures the task has likely run and was successful.
    if ! [ -d "${flutterMod}/.git" ]; then
      echo ""
      echo "--------------------------------------------------------------------------"
      echo "WARNING: Modifiable Flutter SDK at ${flutterMod} seems not properly installed (missing .git directory)."
      echo "Please run 'devenv task flutter-sdk:install' and then re-enter the shell with 'devenv shell'."
      echo "--------------------------------------------------------------------------"
    else
      echo "Modifiable Flutter SDK seems to be in place at ${flutterMod}"
    fi
  '';
}
