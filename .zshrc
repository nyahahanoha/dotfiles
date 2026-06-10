function keyscan() {
  host=$1
  echo "delete $host from known_hosts"
  ssh-keygen -R $host
  echo "add $host to known_hosts"
  ssh-keyscan -H $host >> "$HOME"/.ssh/known_hosts
}

export PS1="\$ "
export EDITOR=hx
export GOPATH="$HOME/.go"

eval "$(/usr/libexec/path_helper)"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="$PATH:/opt/homebrew/opt/libpcap/bin"
eval "$(mise activate zsh)"

if [ -z "$ZELLIJ" ]; then
  herdr; exit
fi

alias -- k=kubectl
alias -- la='ls -a'
alias -- ll='ls -l'
alias -- lla='ls -la'
alias -- ls='ls -1 --color'
alias -- md2pdf='pandoc --pdf-engine=lualatex -V documentclass=bxjsarticle -V classoption=pandoc'

autoload -Uz compinit
if [ $(date +%j) -ne $(stat -f %m ~/.zcompdump 2>/dev/null || echo 0) ]; then
  compinit
else
  compinit -C
fi

source <(kubectl completion zsh)

