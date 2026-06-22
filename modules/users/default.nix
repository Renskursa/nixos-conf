{ config, pkgs, lib, usernames, ... }:

{
  users.users = lib.genAttrs usernames (name: {
    isNormalUser = true;
    description = name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "gamemode"
      "input"
      "audio"
      "video"
      "render"
      "kvm"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  });

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "kubectl" "rust" "golang" "python" ];

    };
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
    '';
  };

  services.displayManager.autoLogin.enable = builtins.length usernames == 1;
  services.displayManager.autoLogin.user = builtins.head usernames;
}
