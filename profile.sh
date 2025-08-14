PATH="$HOME/Documents/scripts:$HOME/go/bin:$PATH"
export PATH
export NNN_PLUG='i:-!|mediainfo $nnn;d:dragdrop;f:fzcd;p:preview-tui;m:mtpmount;j:autojump'
export NNN_BMS="d:~/Documents;p:~/Pictures;v:~/Videos;m:~/Music;h:~/;u:/media/$USERNAME;D:~/Downloads;M:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/mounts;a:/run/user/$UID/gvfs"
export NNN_TRASH=1 # use trash-cli: https://pypi.org/project/trash-cli/
export NNN_FIFO=/tmp/nnn.fifo
export NNN_BATTHEME="Visual Studio Dark+"
export NNN_BATSTYLE="plain"
# export NNN_RCLONE='rclone mount --vfs-cache-mode full --vfs-cache-max-size 5G'
export NNN_RCLONE='rclone mount --vfs-cache-mode writes'
export BAT_THEME="Visual Studio Dark+"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git,.wine}"'
export EDITOR="hx"
export SUDO_EDITOR="/usr/bin/hx"
