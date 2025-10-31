{ config, pkgs, ... }:

{
  # Install Ulauncher
  environment.systemPackages = with pkgs; [
    ulauncher
  ];

  # Enable Ulauncher as a systemd user service
  # This ensures it starts automatically on login
  systemd.user.services.ulauncher = {
    description = "Ulauncher application launcher";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
