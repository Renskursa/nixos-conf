{ config, lib, pkgs, ... }:

{
  # Enable libvirt for virtualization
  virtualisation.libvirtd.enable = true;

  # Add user to libvirt group
  users.groups.libvirtd.members = [ "renskursa" ];

  # Kernel modules for KVM and VFIO
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];

  # Kernel parameters for IOMMU
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  # VFIO PCI device isolation for RTX 3050 Mobile GPU and audio
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:25a2,10de:2291
  '';

  # Blacklist Nvidia drivers on host for passthrough
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];

  # Required packages
  environment.systemPackages = with pkgs; [
    virt-manager
    OVMF
  ];
}