# Add to $PATH
PATH="$HOME/.deno/bin:$HOME/Documents/scripts:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH"
export PATH

# Aliases
alias ls="ls -ltha --color --group-directories-first --hyperlink=auto"
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100"
alias ebrc='xdg-open ~/.bashrc && source ~/.bashrc'
alias ai="aichat"
alias n="nnn"

# Functions
md() {
  filename="${1##*/}"
  pandoc --self-contained --metadata title="Preview" "$1" -o /tmp/"$filename".html
  xdg-open /tmp/"$filename".html
}

ghpr() { GH_FORCE_TTY=100% gh pr list --limit 300 |
  fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window 'down,70%' --header-lines 3 |
  awk '{print $1}' |
  xargs gh pr checkout; }

wordcount() { pandoc --lua-filter wordcount.lua "$@"; }

# nnn
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1" # prompt you are within a shell that will return you to nnn
export NNN_PLUG='i:-!|mediainfo $nnn;d:dragdrop;f:fzcd;p:preview-tui;m:mtpmount;j:autojump'
export NNN_BMS="d:~/Documents;p:~/Pictures;v:~/Videos;m:~/Music;h:~/;u:/media/$USERNAME;D:~/Downloads;M:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/mounts;a:/run/user/$UID/gvfs"
export NNN_TRASH=1 # use trash-cli: https://pypi.org/project/trash-cli/
export NNN_FIFO=/tmp/nnn.fifo
export NNN_BATTHEME="Visual Studio Dark+"
export NNN_BATSTYLE="plain"
export NNN_RCLONE='rclone mount --vfs-cache-mode writes'

# bat
export BAT_THEME="Visual Studio Dark+"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git,.wine}"'
source /usr/share/doc/fzf/examples/key-bindings.bash

# zoxide
eval "$(zoxide init bash)"

stty -ixon # disable terminal flow control

# aichat and aider
export OPENAI_API_KEY="xxx"
export TOGETHERAI_API_KEY="xxx"
export TOGETHER_API_KEY="xxx"
