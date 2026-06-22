{ config, pkgs, lib, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # Packages from flake inputs
  # This module expects 'inputs' to be passed from flake.nix
  environment.systemPackages = [


    # Cursor IDE
    inputs.cursor-nixos-flake.packages.${system}.default

    # Claude Code - Anthropic's agentic coding CLI
    inputs.claude-code.packages.${system}.default

    # Google Antigravity - Agentic IDE & CLI
    inputs.antigravity.packages.${system}.google-antigravity-cli
    inputs.antigravity.packages.${system}.google-antigravity-ide
  ] ++ lib.optionals config.services.desktopManager.plasma6.enable [
    # KDE Effects (only on Plasma)
    inputs.kwin-effects-forceblur.packages.${system}.default
  ];
}
