# Aliases
alias ls="ls -ltha --color --group-directories-first --hyperlink=auto"
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100"
alias ebrc='xdg-open ~/.bashrc && source ~/.bashrc'
alias ai="aichat"
alias n="nnn"
alias ssh="kitten ssh"

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

# fzf
source /usr/share/doc/fzf/examples/key-bindings.bash

# zoxide
eval "$(zoxide init bash)"

# aichat and aider
export TOGETHERAI_API_KEY="xxx"
export TOGETHER_API_KEY="xxx"

stty -ixon # disable terminal flow control
