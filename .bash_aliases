#!/bin/bash

# Sources:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
#   http://dev-spout.blogspot.com/2011/07/mac-terminal-colors-git-prompt.html

alias ls="ls -GAFh"
if [[ -x "`which gls`" ]]; then
  alias ls="gls -GAFh --color"
fi

alias grep="grep --color=auto"
alias ll="ls -l"
alias lsd='ll | grep "^d"'
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'
alias cls="clear"
alias c="clear"
alias s="subl"
alias m="mate"
alias h="history | grep"
alias top="top -o cpu"

if [[ "$OSTYPE" =~ ^darwin ]]; then
  # OS X has no `md5sum`, so use `md5` as a fallback
  type -t md5sum > /dev/null || alias md5sum="md5"

  # Recursively delete `.DS_Store` files
  alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

  # Show/hide hidden files in Finder
  alias show_hidden="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
  alias hide_hidden="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

  # Hide/show all desktop icons (useful when presenting)
  alias hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
  alias show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
fi

# File size
alias fs="stat -f \"%z bytes\""

# Shortcuts
alias sshconf="subl ~/.ssh/config"

# Dump all colors to terminal
alias colors='{
  echo -e -n "${BLACK}BLACK\t${LIGHT_BLACK}LIGHT_BLACK\t${ON_WHITE}${BLACK}BLACK${NO_COLOUR}\n"
  echo -e -n "${RED}RED\t${LIGHT_RED}LIGHT_RED\t${ON_WHITE}${RED}RED${NO_COLOUR}\n"
  echo -e -n "${GREEN}GREEN\t${LIGHT_GREEN}LIGHT_GREEN\t${ON_WHITE}${GREEN}GREEN${NO_COLOUR}\n"
  echo -e -n "${YELLOW}YELLOW\t${LIGHT_YELLOW}LIGHT_YELLOW\t${ON_WHITE}${YELLOW}YELLOW${NO_COLOUR}\n"
  echo -e -n "${BLUE}BLUE\t${LIGHT_BLUE}LIGHT_BLUE\t${ON_WHITE}${BLUE}BLUE${NO_COLOUR}\n"
  echo -e -n "${PURPLE}PURPLE\t${LIGHT_PURPLE}LIGHT_PURPLE\t${ON_WHITE}${PURPLE}PURPLE${NO_COLOUR}\n"
  echo -e -n "${CYAN}CYAN\t${LIGHT_CYAN}LIGHT_CYAN\t${ON_WHITE}${CYAN}CYAN${NO_COLOUR}\n"
  echo -e -n "${WHITE}WHITE\t${LIGHT_WHITE}LIGHT_WHITE\t${ON_WHITE}${WHITE}WHITE${NO_COLOUR}\n"
}'
