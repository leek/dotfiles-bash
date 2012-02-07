# Sources:
#     https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{exports,aliases,functions,bash_prompt,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Notify of bg job completion immediately
set -o notify

shopt -s nocaseglob

# Check for window resizing when ever the prompt is displayed
shopt -s checkwinsize

# No mail notifications
shopt -u mailwarn
unset MAILCHECK

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

complete -d cd mkdir rmdir