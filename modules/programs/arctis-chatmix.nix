{ config, pkgs, inputs, ... }:

let
  # Fetch the repository
  arctis-repo = inputs.arctis-chatmix-src;

  # Create a Python environment with PyUSB
  arctis-python = pkgs.python3.withPackages (ps: with ps; [
    pyusb
  ]);

  # Create a patched version of the script for Arctis Nova 7
  # Nova 7 uses idProduct=0x22ff instead of 0x220e
  arctis-script-patched = pkgs.runCommand "arctis-nova-7-script" {} ''
    mkdir -p $out
    cp ${arctis-repo}/Arctis_7_Plus_ChatMix.py $out/Arctis_7_Plus_ChatMix.py
    
    # Patch the USB product ID for Arctis Nova 7
    sed -i 's/idProduct=0x220e/idProduct=0x22ff/g' $out/Arctis_7_Plus_ChatMix.py
    
    # Also update the error message to mention Nova 7
    sed -i "s/Please note: This program only supports the '7+' model./Please note: This version supports the Nova 7 model./g" $out/Arctis_7_Plus_ChatMix.py
  '';

  # Create udev rules for both Arctis 7+ and Nova 7
  udev-rules = pkgs.writeTextFile {
    name = "99-arctis-headsets.rules";
    text = ''
      # SteelSeries Arctis 7+ USB Dongle
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="220e", MODE="0660", GROUP="input"
      # SteelSeries Arctis Nova 7 USB Dongle
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="22ff", MODE="0660", GROUP="input"
    '';
    destination = "/etc/udev/rules.d/99-arctis-headsets.rules";
  };

in
{
  # Install Python with PyUSB
  environment.systemPackages = with pkgs; [
    arctis-python
    pulseaudio # for pactl
  ];

  # Add udev rules
  services.udev.packages = [ udev-rules ];

  # Enable the systemd user service for Arctis 7+
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

  # Enable the systemd user service for Arctis Nova 7
  systemd.user.services.arctis-nova7-chatmix = {
    description = "Arctis Nova 7 ChatMix Service";
    after = [ "sound.target" "pipewire.service" ];
    wantedBy = [ "default.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${arctis-python}/bin/python ${arctis-script-patched}/Arctis_7_Plus_ChatMix.py";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
