HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd beep
bindkey -v
zstyle :compinstall filename "$HOME/.zshrc"
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{#888888} (%F{#888888}󰘬 %b)%f'
precmd() { vcs_info }
PROMPT='%n@%m:%~${vcs_info_msg_0_}%(!.#.$) '

# use zsh-autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -M vicmd 'U' redo # use Helix redo shortcut
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^ ' autosuggest-accept

# Add to $PATH
PATH="$HOME/.deno/bin:$HOME/Documents/scripts:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/kitty.app/bin:$PATH"
export PATH

# Aliases
alias ls="ls -ltha --color --group-directories-first --hyperlink=auto"
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100"
alias ezrc='hx ~/.zshrc && source ~/.zshrc'
alias ai="aichat"
alias aif="aichat -r %functions% "
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
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git,.wine}"'
source /usr/share/doc/fzf/examples/key-bindings.zsh

# zoxide
eval "$(zoxide init zsh)"

stty -ixon # disable terminal flow control
export EDITOR="hx"
export SUDO_EDITOR="$HOME/.cargo/bin/hx"
