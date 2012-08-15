#!/bin/bash

# Sources:
#     https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

for file in ~/.dotfiles/.{extra,exports,bash_aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

if [ -f ~/.extra ]; then
	source ~/.extra
fi

# Notify of bg job completion immediately
set -o notify

# Check for window resizing when ever the prompt is displayed
shopt -s checkwinsize

# Append to ~/.bash_history
shopt -s histappend
shopt -s nocaseglob

# No mail notifications
shopt -u mailwarn
unset MAILCHECK

# Tab completion for ~/.ssh/config
if [[ -e ~/.ssh/config ]]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh
fi

# Tab completion for ~/.ssh/known_hosts
if [[ -e ~/.ssh/known_hosts ]]; then
    complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" scp sftp ssh
fi

complete -d cd mkdir rmdir
