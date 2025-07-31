{ config, pkgs, ... }:
{
  programs.i3blocks = {
    enable = true;

    bars.default = {
      blocks = [
        {
          label = "DT";  # datetime
          command = "${pkgs.coreutils}/bin/date '+%a%d/%m %H:%M'";
          interval = 10;
        }
        {
          label = "BAT";  # battery %
          command = "${pkgs.acpi}/bin/acpi -b | grep -o '[0-9]\\+%' | head -n1";
          interval = 15;
        }
        {
          label = "VOL";  # volume %
          command = "${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\\+%' | head -n1";
          interval = 5;
        }
        {
          label = "RAM";  # used/total ram
          command = "${pkgs.procps}/bin/free -h | awk '/Mem:/ {print $3 \"/\" $2}'";
          interval = 7;
        }
        {
          label = "CPU";  # load avg
          command = "${pkgs.procps}/bin/uptime | awk -F'load average: ' '{print $2}'";
          interval = 5;
        }
        {
          label = "NET";  # ip
          command = "${pkgs.iproute2}/bin/ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1";
          interval = 20;
        }
        {
          label = "PKG";  # # of user pkgs
          command = "nix profile list | grep -c '^\\s*\\d'";
          interval = 300;
        }
        {
          label = "TMP";  # /tmp space
          command = "${pkgs.coreutils}/bin/df -h /tmp | awk 'NR==2{print $3\"/\"$2}'";
          interval = 60;
        }
        {
          label = "NIX";  # nix store size
          command = "${pkgs.du}/bin/du -sh /nix/store | cut -f1";
          interval = 600;
        }
        {
          label = "GEN";  # system generations
          command = "ls /nix/var/nix/profiles/system-*-link | wc -l";
          interval = 900;
        }
        {
          label = "FAIL";  # last failed unit
          command = "${pkgs.systemd}/bin/systemctl --failed --no-pager --no-legend | head -n1 | awk '{print $1}'";
          interval = 60;
        }
        {
          label = "TTY";  # current tty
          command = "${pkgs.coreutils}/bin/tty | sed 's:/dev/::'";
          interval = 120;
        }
        {
          label = "SH";  # default shell
          command = "getent passwd $USER | cut -d: -f7";
          interval = 300;
        }
        {
          label = "TMP°";  # cpu temp
          command = "cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f°C\", $1/1000}'";
          interval = 15;
        }
        {
          label = "HN";  # hostname
          command = "${pkgs.coreutils}/bin/hostname -s";
          interval = 1000;
        }
      ];
    };
  };
}

