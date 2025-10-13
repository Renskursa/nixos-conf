{ config, pkgs, ... }:

let
  # Fetch the repository
  arctis-repo = pkgs.fetchFromGitHub {
    owner = "awth13";
    repo = "Linux-Arctis-7-Plus-ChatMix";
    rev = "main";
    sha256 = "sha256-0fz57pyv8d7n76d2cv885i1h909nshnlbm22rq1rqp52q29s56gd";
  };

  # Create a Python environment with PyUSB
  arctis-python = pkgs.python3.withPackages (ps: with ps; [
    pyusb
  ]);

  # Create the systemd service script
  arctis-service = pkgs.writeTextFile {
    name = "arctis7pcm.service";
    text = ''
      [Unit]
      Description=Arctis 7+ ChatMix Service
      After=sound.target pipewire.service

      [Service]
      Type=simple
      ExecStart=${arctis-python}/bin/python ${arctis-repo}/Arctis_7_Plus_ChatMix.py
      Restart=on-failure
      RestartSec=5s

      [Install]
      WantedBy=default.target
    '';
  };

  # Create udev rules
  udev-rules = pkgs.writeTextFile {
    name = "99-arctis7plus.rules";
    text = ''
      # SteelSeries Arctis 7+ USB Dongle
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="12c2", MODE="0666"
    '';
    destination = "/etc/udev/rules.d/99-arctis7plus.rules";
  };

in
{
  # Install Python with PyUSB
  environment.systemPackages = with pkgs; [
    arctis-python
    pipewire
    pulseaudio # for pactl
  ];

  # Add udev rules
  services.udev.packages = [ udev-rules ];

  # Enable the systemd user service
  systemd.user.services.arctis7pcm = {
    description = "Arctis 7+ ChatMix Service";
    after = [ "sound.target" "pipewire.service" ];
    wantedBy = [ "default.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${arctis-python}/bin/python ${arctis-repo}/Arctis_7_Plus_ChatMix.py";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
