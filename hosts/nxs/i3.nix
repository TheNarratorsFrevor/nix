{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod1"; # Alt key
      terminal = "alacritty";

      fonts = {
        names = [ "Fira Code" ];
        size = 10.0;
      };

      gaps = {
        inner = 0;
        smartGaps = false;
      };

      window = {
        border = 0;
        titlebar = false;
      };

      focus.followMouse = true;
      floating.modifier = "Mod1";
      keybindings = {
        "Mod1+Return" = "exec alacritty";
        "Mod1+q" = "kill";
        "Mod1+p" = "exec feh --bg-fill -r -z ~/Pictures/winrip";
        "Mod1+d" = "exec rofi -show drun";

        # Volume control
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Focus
        "Mod1+j" = "focus left";
        "Mod1+k" = "focus down";
        "Mod1+l" = "focus up";
        "Mod1+semicolon" = "focus right";
        "Mod1+Left" = "focus left";
        "Mod1+Down" = "focus down";
        "Mod1+Up" = "focus up";
        "Mod1+Right" = "focus right";

        # Move
        "Mod1+Shift+j" = "move left";
        "Mod1+Shift+k" = "move down";
        "Mod1+Shift+l" = "move up";
        "Mod1+Shift+semicolon" = "move right";
        "Mod1+Shift+Left" = "move left";
        "Mod1+Shift+Down" = "move down";
        "Mod1+Shift+Up" = "move up";
        "Mod1+Shift+Right" = "move right";

        # Layout
        "Mod1+h" = "split h";
        "Mod1+v" = "split v";
        "Mod1+f" = "fullscreen toggle";
        "Mod1+s" = "layout stacking";
        "Mod1+w" = "layout tabbed";
        "Mod1+e" = "layout toggle split";
        "Mod1+Shift+space" = "floating toggle";
        "Mod1+space" = "focus mode_toggle";

        "Mod1+a" = "focus parent";

        # Workspaces
        "Mod1+1" = "workspace number 1";
        "Mod1+Shift+1" = "move container to workspace number 1";
        "Mod1+2" = "workspace number 2";
        "Mod1+Shift+2" = "move container to workspace number 2";
        "Mod1+3" = "workspace number 3";
        "Mod1+Shift+3" = "move container to workspace number 3";
        "Mod1+4" = "workspace number 4";
        "Mod1+Shift+4" = "move container to workspace number 4";
        "Mod1+5" = "workspace number 5";
        "Mod1+Shift+5" = "move container to workspace number 5";
        "Mod1+6" = "workspace number 6";
        "Mod1+Shift+6" = "move container to workspace number 6";
        "Mod1+7" = "workspace number 7";
        "Mod1+Shift+7" = "move container to workspace number 7";
        "Mod1+8" = "workspace number 8";
        "Mod1+Shift+8" = "move container to workspace number 8";
        "Mod1+9" = "workspace number 9";
        "Mod1+Shift+9" = "move container to workspace number 9";
        "Mod1+0" = "workspace number 10";
        "Mod1+Shift+0" = "move container to workspace number 10";

        # Screenshot
        "Print" = "exec flameshot gui";

        # i3 management
        "Mod1+Shift+c" = "reload";
        "Mod1+Shift+r" = "restart";
        "Mod1+Shift+e" = ''exec "i3-nagbar -t warning -m 'Exit i3?' -B 'Yes, exit' 'i3-msg exit'"'';

        # Resize mode
        "Mod1+r" = "mode resize";
      };

      modes = {
        resize = {
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Return" = "mode default";
          "Escape" = "mode default";
          "Mod1+r" = "mode default";
        };
      };

      startup = [
        { command = "xmodmap ~/.Xmodmap"; always = true; }
        { command = "xinput --set-prop '$(xinput list --name-only | grep -i touchpad)' 'libinput Natural Scrolling Enabled' 1"; always = true; }

        { command = "setxkbmap -option grp:alt_caps_toggle -layout us,ir"; }
        { command = "feh --bg-fill -r -z ~/Pictures/Wallpapers/wall.png"; always = true; }
        { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; }
      ];
      colors = {
        focused = {
          border = "#2e3440";
          background = "#2e3440";
          text = "#eceff4";
          indicator = "#2e3440";
          childBorder = "#2e3440";
        };
        unfocused = {
          border = "#3b4252";
          background = "#3b4252";
          text = "#4c566a";
          indicator = "#3b4252";
          childBorder = "#3b4252";
        };
        focusedInactive = {
          border = "#3b4252";
          background = "#3b4252";
          text = "#4c566a";
          indicator = "#3b4252";
          childBorder = "#3b4252";
        };
        urgent = {
          border = "#bf616a";
          background = "#bf616a";
          text = "#eceff4";
          indicator = "#bf616a";
          childBorder = "#bf616a";
        };
      };
      programs.i3blocks = {
        enable = true;
        bars = {
          default = {
            position = "top";
            statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${pkgs.writeText "i3blocks.conf" ''
          [time]
          command=${formatScript "date +'%a%d %b %H:%M'"}
          interval=60

          [cpu]
          command=${formatScript "awk -v RS= '{usage=($13+$14)*100/($2+$4+$5); printf \"cpu %.0f%%\", usage}' /proc/stat"}
          interval=2

          [mem]
          command=${formatScript "free -m | awk '/Mem:/ {printf \"ram %d/%dMB\", \$3, \$2}'"}
          interval=5

          [disk]
          command=${formatScript "df -h / | awk '/\\// {printf \"disk %s/%s\", \$3, \$2}'"}
          interval=60

          [net]
          command=${formatScript "ip r | grep default | awk '{print $3}' | xargs -I{} ping -c 1 {} | awk -F'=' '/time=/{print \"net \" \$NF}'"}
          interval=10

          [pkg]
          command=${formatScript "${pkgs.nix}/bin/nix-store --gc --print-dead | wc -l | awk '{print \"gc \" \$1}'"}
          interval=600

          [temp]
          command=${formatScript "sensors | grep -Po 'Package id 0: +\\+\\K[0-9.]+' | awk '{print \"temp \"$1\"°C\"}'"}
          interval=10

          [uptime]
          command=${formatScript "uptime -p | sed 's/up //' | awk '{print \"up \"$0}'"}
          interval=60
        ''}";
		};

          };
        };
      }
