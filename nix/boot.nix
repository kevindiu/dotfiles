{ config, pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot = {
    # blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelModules = ["psmouse" "i2c_i801" "elan_i2c" "rmi_smbus"  "kvm_intel"];
    # kernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"]; # thinkpad x1 gen5 available
    kernelModules = ["xhci_pci" "nvme" ]; # thinkpad x1 gen5 available
    kernelParams = [
      "acpi.ec_no_wakeup=1"
      "console=ttyS0,19200n8"
      "intel_pstate=no_hwp"
      "psmouse.proto=imps"
      "psmouse.synaptics_intertouch=1"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    tmpOnTmpfs = true;
    cleanTmpDir = true;
    plymouth = {
      enable = true;
    };
    supportedFilesystems = [ "xfs" ];
    earlyVconsoleSetup = true;
    kernel = {
      sysctl = {
        "fs.aio-max-nr" = 19349474;
        "fs.aio-nr" = 0;
        "fs.epoll.max_user_watches" = 39688724;
        "fs.file-max" = 19349474;
        "fs.file-nr" = "288 0 19349474";
        "kernel.panic" = 30;
        "kernel.perf_event_paranoid" = 0;
        "kernel.threads-max" = 4000000;
        "net.core.default_qdisc" = "fq";
        "net.core.netdev_max_backlog" = 4096;
        "net.core.optmem_max" = 40960;
        "net.core.rmem_default" = 16777216;
        "net.core.rmem_max" = 16777216;
        "net.core.somaxconn" = 30000;
        "net.core.wmem_default" = 16777216;
        "net.core.wmem_max" = 16777216;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_source_route" = 0;
        "net.ipv4.conf.lo.accept_redirects" = 0;
        "net.ipv4.conf.lo.accept_source_route" = 0;
        "net.ipv4.conf.wlp4s0.accept_redirects" = 0;
        "net.ipv4.conf.wlp4s0.accept_source_route" = 0;
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.tcp_abort_on_overflow" = 1;
        "net.ipv4.tcp_allowed_congestion_control" = "bbr reno";
        "net.ipv4.tcp_available_congestion_control" = "bbr reno";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_fack" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_fin_timeout" = 30;
        "net.ipv4.tcp_keepalive_intvl" = 5;
        "net.ipv4.tcp_keepalive_probes" = 4;
        "net.ipv4.tcp_keepalive_time" = 20;
        "net.ipv4.tcp_low_latency" = 0;
        "net.ipv4.tcp_max_syn_backlog" = 30000;
        "net.ipv4.tcp_max_tw_buckets" = 2000000;
        "net.ipv4.tcp_moderate_rcvbuf" = 1;
        "net.ipv4.tcp_no_metrics_save" = 1;
        "net.ipv4.tcp_orphan_retries" = 3;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.tcp_rmem" = "4096 87380 16777216";
        "net.ipv4.tcp_sack" = 1;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_timestamps" = 0;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_window_scaling" = 1;
        "net.ipv4.tcp_wmem" = "4096 87380 16777216";
        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
        "vm.max_map_count" = 262144;
        "vm.overcommit_memory" = 2;
        "vm.overcommit_ratio" = 99;
        "vm.panic_on_oom" = 1;
        "vm.swappiness" = 1;
      };
    };
    loader = {
      # systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "2560x1440";
        timeout = 10;
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
        # enableCryptodisk = true;
        # extraInitrd = "/boot/initrd.keys.gz";
      };
    };
    initrd = {
      kernelModules = [
        # "elan_i2c"
        # "i2c_i801"
        "kvm_intel"
        "psmouse"
        # "rmi_smbus"
        # "xhci_pci"
        "nvme"
        # "usb_storage"
        # "sd_mod"
        # "rtsx_pci_sdmmc"
      ];
      # luks.devices = [
      #   {
      #     name = "root";
      #     device = "/dev/disk/by-uuid/UUID";
      #     preLVM = true;
      #     allowDiscards = true;
      #     keyFile = "/hdd.key";
      #     keyFileSize = 4096;
      #   }
      # ];
    };
  };
}
