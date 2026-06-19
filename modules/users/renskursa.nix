{ config, pkgs, ... }:

{
  users.users.renskursa = {
    isNormalUser = true;
    description = "renskursa";
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
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "kubectl" "rust" "golang" "python" ];
      theme = "agnoster";
    };
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "renskursa";
}
