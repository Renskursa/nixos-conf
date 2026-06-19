{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # Packages from flake inputs
  # This module expects 'inputs' to be passed from flake.nix
  environment.systemPackages = [
    pkgs.winboat

    # KDE Effects
    inputs.kwin-effects-forceblur.packages.${system}.default

    # Cursor IDE
    inputs.cursor-nixos-flake.packages.${system}.default

    # Claude Code - Anthropic's agentic coding CLI
    inputs.claude-code.packages.${system}.default

    # Google Antigravity - Agentic IDE & CLI
    inputs.antigravity.packages.${system}.google-antigravity-cli
    inputs.antigravity.packages.${system}.google-antigravity-ide
  ];
}
