#!/bin/bash

# Sources:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
#   http://dev-spout.blogspot.com/2011/07/mac-terminal-colors-git-prompt.html

# Always use color output for `ls`
if [[ -x "`which gdircolors`" ]] || [[ -x "`which dircolors`" ]]; then
  export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.yuv=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.flac=01;35:*.mp3=01;35:*.mpc=00;36:*.ogg=00;36:*.wav=00;36:*.mid=00;36:*.midi=00;36:*.au=00;36:*.flac=00;36:*.aac=00;36:*.ra=01;36:*.mka=01;36:';
else
  export LSCOLORS=gxfxcxdxbxegedabagacad
fi

LS_COMMAND="ls"
LS_OPTIONS="-GAFh"
if [[ -x "`which gls`" ]]; then
  LS_COMMAND="gls"
  LS_OPTIONS="$LS_OPTIONS --color"
fi

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ls="$LS_COMMAND $LS_OPTIONS"
alias ll="$LS_COMMAND $LS_OPTIONS -l"
alias lsd='$LS_COMMAND $LS_OPTIONS -l | grep "^d"'
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'
alias cls="clear"
alias c="clear"
alias s="subl"
alias m="mate"
alias h="history | grep"

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
