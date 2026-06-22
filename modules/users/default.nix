{ config, pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
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
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
    '';
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;
}
