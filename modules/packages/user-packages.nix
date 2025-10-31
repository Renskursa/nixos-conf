{ config, pkgs, ... }:

{
  # User-specific packages
  # These are separated by category for easier management
  
  users.users.renskursa.packages = with pkgs; [
    # Communication
    discord-ptb
    
    # Browsers
    google-chrome
    
    # Remote Access
    freerdp

    localsend
    
    # You can add more categories here:
    # Development
    # Media & Graphics
    # Productivity
    # etc.
  ];
}
