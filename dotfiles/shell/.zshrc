# History configuration
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Shell options
unsetopt autocd beep
bindkey -v
setopt PROMPT_SUBST

# Load and configure VCS (Version Control System) information
autoload -Uz vcs_info

# Configure VCS info style for Git repositories
zstyle ':vcs_info:git:*' formats '%F{#888888} (%F{#888888}󰘬 %b)%f'

# Function to set VCS information before each prompt
precmd() { vcs_info }

# Custom prompt including VCS information
PROMPT='%n@%m:%~${vcs_info_msg_0_}%(!.#.$) '

# Completion system initialization
autoload -Uz compinit
compinit

# Autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Key bindings:
bindkey '^ ' autosuggest-accept
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Redo operation in Vi command mode (using Helix redo shortcut)
bindkey -M vicmd 'U' redo

# Aliases
alias ls="ls -ltha --color --group-directories-first --hyperlink=auto"
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100"
alias ezrc='hx ~/.zshrc && source ~/.zshrc'
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
source /usr/share/doc/fzf/examples/key-bindings.zsh

# zoxide
eval "$(zoxide init zsh)"

# aichat and aider
export OPENAI_API_KEY="xxx"
export TOGETHERAI_API_KEY="xxx"
export TOGETHER_API_KEY="xxx"

stty -ixon # disable terminal flow control
