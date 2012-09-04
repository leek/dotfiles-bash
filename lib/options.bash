# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and update LINES/COLUMNS
shopt -s checkwinsize

# Don't close Terminal when sending CTRL+D
shopt -s -o ignoreeof

# Enable some Bash 4 features when possible:
#   * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
#   * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

shopt -s dotglob
shopt -s no_empty_cmd_completion
shopt -u mailwarn
