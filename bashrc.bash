# Add to $PATH
PATH="$HOME/.deno/bin:$HOME/Documents/scripts:$PATH"
export PATH

# Aliases
alias ls="ls -ltha --color --group-directories-first --hyperlink=auto"
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100"
alias ebrc='xdg-open ~/.bashrc && source ~/.bashrc'
alias ai="sgpt --model='gpt-4-1106-preview'"

# Functions
md() {
    filename="${1##*/}"
    pandoc --self-contained "$1" -o /tmp/"$filename".html
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
export NNN_BMS="d:~/Documents;p:~/Pictures;v:~/Videos;m:~/Music;h:~/;u:/run/media/$USERNAME;D:~/Downloads;M:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/mounts"
export NNN_TRASH=1 # use trash-cli: https://pypi.org/project/trash-cli/
export NNN_FIFO=/tmp/nnn.fifo
export NNN_BATTHEME="Visual Studio Dark+"
export NNN_BATSTYLE="plain"

# bat
export BAT_THEME="Visual Studio Dark+"
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git,.wine}"'
source /usr/share/doc/fzf/examples/key-bindings.bash

# ytfzf
export video_pref="bestvideo[height<=?2160]+bestaudio/best"
alias ytfzf='ytfzf -T kitty'

# zoxide
eval "$(zoxide init bash)"

stty -ixon # disable terminal flow control
export OPENAI_API_KEY="enter your key here"
