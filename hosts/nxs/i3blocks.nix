{ config, pkgs, ... }:

{
  programs.i3blocks = {
    enable = true;

    bars = {
      default = {
        dt = {
          label = "DT ";
          command = "${pkgs.coreutils}/bin/date '+%a%d/%m %H:%M'";
          interval = 10;
        };
        bat = {
          label = "BAT ";
          command = "${pkgs.acpi}/bin/acpi -b | grep -o '[0-9]\\+%' | head -n1";
          interval = 15;
        };
        vol = {
          label = "VOL";
          command = ''
            ${pkgs.pipewire}/bin/wpctl get-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1
          '';
          interval = 5;
        };

        ram = {
          label = "RAM ";
          command = "${pkgs.procps}/bin/free -h | awk '/Mem:/ {print \$3 \"/\" \$2}'";
          interval = 7;
        };
        cpu = {
          label = "CPU ";
          command = "${pkgs.procps}/bin/uptime | awk -F'load average: ' '{print \$2}'";
          interval = 5;
        };
        net = {
          label = "NET ";
          command = "${pkgs.iproute2}/bin/ip -4 addr show scope global | grep inet | awk '{print \$2}' | cut -d/ -f1 | head -n1";
          interval = 20;
        };
        pkg = {
          label = "PKG ";
          command = "nix profile list | grep -c '^\\s*\\d'";
          interval = 300;
        };
        tmp = {
          label = "TMP ";
          command = "${pkgs.coreutils}/bin/df -h /tmp | awk 'NR==2{print \$3\"/\"$2}'";
          interval = 60;
        };
        nix = {
          label = "NIX ";
          command = "${pkgs.coreutils}/bin/du -sh /nix/store | cut -f1";
          interval = 600;
        };
        gen = {
          label = "GEN ";
          command = "nixos-rebuild list-generations | grep -oE '[0-9]+' | head -n1";
          interval = 900;
        };
        fail = {
          label = "FAIL ";
          command = "${pkgs.systemd}/bin/systemctl --failed --no-pager --no-legend | head -n1 | awk '{print \$1}'";
          interval = 60;
        };
        sh = {
          label = "SH ";
          command = "getent passwd \$USER | cut -d: -f7";
          interval = 300;
        };
        tmpc = {
          label = "TMP° ";
          command = "cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f°C\", \$1/1000}'";
          interval = 15;
        };
        hn = {
          label = "HN ";
          command = "${pkgs.coreutils}/bin/hostname -s";
          interval = 1000;
        };
      };
    };
  };
}

