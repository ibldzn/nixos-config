{ config, pkgs, ... }:
{
  hardware.cpu.intel.updateMicrocode = true;

  boot.loader = {
    timeout = 5;
    systemd-boot = {
      enable = true;
      editor = false;
    };
    efi.canTouchEfiVariables = false;
  };

  time.timeZone = "Asia/Jakarta";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx.engines = [ pkgs.fcitx-engines.mozc ];
    };
  };

  networking = {
    useDHCP               = false;
    hostName              = "nixos";
    hostFiles             = [ ./res/hosts ];
    networkmanager.enable = true;
  };

  services = {
    gvfs.enable                = true;
    printing.enable            = true;
    gnome.gnome-keyring.enable = true;

    openssh = {
      enable                 = true;
      permitRootLogin        = "no";
      passwordAuthentication = true;
    };

    xserver = {
      layout     = "us";
      xkbOptions = "caps:ctrl_modifier";
    };
  };
}
