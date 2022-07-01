{ pkgs, ... }:
{
  hardware.cpu.intel.updateMicrocode = true;

  boot = {
    cleanTmpDir = true;
    loader = {
      timeout = 5;
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = false;
    };
  };

  time.timeZone = "Asia/Jakarta";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_TIME = "ja_JP.UTF-8"; };
    inputMethod = {
      enabled = "fcitx5";
      fcitx.engines = [ pkgs.fcitx-engines.mozc ];
    };
  };

  networking = {
    interfaces = {
      enp2s0.useDHCP      = true;
      wlp0s20f0u3.useDHCP = true;
    };

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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryMax = 8 * 1024 * 1024 * 1024; # 8GB
  };
}
