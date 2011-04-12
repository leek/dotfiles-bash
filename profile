# Locale
export LANG=en_AU.UTF-8
export LC_CTYPE=en_US.UTF-8

# General
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
export CLICOLOR=1
export PS1='\u@\h:\w\$ '
export FIGNORE="CVS:.DS_Store:.svn"
export EDITOR='nano'
export PAGER='less -SFX'
export MAKEFLAGS='-j 3'
complete -d cd mkdir rmdir

# Our own bin dir at the highest priority, followed by /usr/local/bin
export GEM_HOME='$(brew --prefix)/Cellar/gems/1.8'
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:"$PATH"

if [ "$TERM_PROGRAM" == "Apple_Terminal" -a -x "`which mate`" ]
then
    # Press V in less to edit the file in TextMate
    export LESSEDIT='mate -l %lm %f'
fi

# Add a key bindings to Terminal.app
if [ "$TERM_PROGRAM" == "Apple_Terminal" ]
then
    function term-bind()
    {
        term "$@" > /dev/null && echo -en "\033[1A"
    }
    # (Ctrl-T for new tab in pwd, Ctrl-N for new window)
    bind -x '"\C-t":term-bind -t'
    bind -x '"\C-n":term-bind'
fi

# Open man pages in Preview.app
if [ -d "/Applications/Preview.app" ]
then
    pman () {
        man -t "$@" |
        ( which ps2pdf > /dev/null && ps2pdf - - || cat) |
        open -f -a /Applications/Preview.app
    }
fi

# Color
if ls --version 2> /dev/null | grep -q 'GNU coreutils'
then
    export GREP_OPTIONS='--color=auto'
    alias ls='ls --color=auto --classify'
fi

#
# Git
#
function git_current_tracking()
{
    local BRANCH="$(git describe --contains --all HEAD)"
    local REMOTE="$(git config branch.$BRANCH.remote)"
    local MERGE="$(git config branch.$BRANCH.merge)"
    if [ -n "$REMOTE" -a -n "$MERGE" ]
    then
        echo "$REMOTE/$(echo "$MERGE" | sed 's#^refs/heads/##')"
    else
        echo "\"$BRANCH\" is not a tracking branch." >&2
        return 1
    fi
}

function glp()
{
    git $(echo "$*" | grep -q -- '--word-diff.*--' && echo --no-pager) log --patch $(echo "$*" | grep -q '\.\.' && echo --reverse) "$@"
}

#
# Aliases
#
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ls="ls -G"
alias ll="ls -al"
alias qt='open -a "QuickTime Player"'
alias gl='git lg --all'
alias glw='glp --word-diff'
alias gco='git co'
alias gcp='git co -p'
alias gst='git status'
alias gd='git diff'
alias gdw='git --no-pager diff --word-diff'
alias gds='gd --cached'
alias gdsw='gdw --cached'
alias gar='git reset HEAD'
alias garp='git reset -p HEAD'
alias gap='git add -p'
alias gau='git ls-files --other --exclude-standard -z | xargs -0 git add -Nv'
alias gaur="git ls-files --exclude-standard --modified -z | xargs -0 git ls-files --stage -z | awk 'BEGIN { RS=\"\0\"; FS=\"\t\"; ORS=\"\0\" } { if (\$1 ~ / e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 /) { sub(/^[^\t]+\t/, \"\", \$0); print } }' | xargs -0t -n 1 git reset -q -- 2>&1 | sed -e \"s/^git reset -q -- /reset '/\" -e \"s/ *$/'/\""
alias gc='EDITOR="mate -wl1" git commit -v'
alias gca='gc --amend'
alias grt='git_current_tracking > /dev/null && git rebase -i $(git_current_tracking)'
alias gp='git push'
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'

#
# Functions
#
function trash () {
    mv $@ ~/.Trash/
}

# History Tracking
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export PROMPT_COMMAND='history -a'
shopt -s histappend
PROMPT_COMMAND='history -a; echo "$$ $USER $(history 1)" >> ~/.bash_eternal_history'

# Notify of bg job completion immediately
set -o notify

# No mail notifications
shopt -u mailwarn
unset MAILCHECK

# Check for window resizing when ever the prompt is displayed
shopt -s checkwinsize

if [ "$TERM" == "xterm" -o "$TERM" == "xterm-color" ]
then
    export PROMPT_COMMAND="$PROMPT_COMMAND; "'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# Load Homebrew's shell completion
if which brew > /dev/null && [ -f `brew --prefix`/etc/bash_completion ]
then
    . `brew --prefix`/etc/bash_completion
fi

function gup
{
    # Subshell for `set -e` and `trap`
    (
        # Fail immediately if there's a problem
        set -e

        # Fetch upstream changes
        git fetch

        BRANCH=$(git describe --contains --all HEAD)
        if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
        then
            echo "\"$BRANCH\" is not a tracking branch." >&2
            exit 1
        fi

        # Create a temp file for capturing command output
        TEMPFILE="`mktemp -t gup.XXXXXX`"
        trap '{ rm -f "$TEMPFILE"; }' EXIT

        # If we're behind upstream, we need to update
        if git status | grep "# Your branch" > "$TEMPFILE"
        then

            # Extract tracking branch from message
            UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
            if [ -z "$UPSTREAM" ]
            then
                echo Could not detect upstream branch >&2
                exit 1
            fi

            # Can we fast-forward?
            CAN_FF=1
            grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0

            # Stash any uncommitted changes
            git stash | tee "$TEMPFILE"
            [ "${PIPESTATUS[0]}" -eq 0 ] || exit 1

            # Take note if anything was stashed
            HAVE_STASH=0
            grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1

            if [ "$CAN_FF" -ne 0 ]
            then
                # If nothing has changed locally, just fast foward.
                git merge --ff "$UPSTREAM"
            else
                # Rebase our changes on top of upstream, but keep any merges
                git rebase -p "$UPSTREAM"
            fi

            # Restore any stashed changed
            [ "$HAVE_STASH" -ne 0 ] && git stash pop -q

        fi
    )
}

#
# Prompt
#
function prompt_command ()
{
    GOOD=$?

    export PS1="\\[\\033[${COLOR}m\\]$USER"
    if [ "$COLOR" == "" ]; then
        export PS1="${PS1}@\\h"
    fi

    WPATH=`echo $PWD | sed "s#$HOME#~#"`
    WPATH2=""
    while [ "$WPATH" != "$WPATH2" ]; do
            WPATH2="$WPATH"
            WPATH=`echo $WPATH | sed "s#/\(..\)[^/][^/]*/#/\\1/#"`
    done
    if [ `echo $WPATH | wc -c` -gt 20 ]; then
            WPATH="\\W"
    fi

    export PS1="${PS1} \\[\\033[00m\\]${WPATH} "

    # Add git status
    export PS1="$PS1"'\[\033[01;30m\]$(__git_ps1 "(%s)")'

    if [ $GOOD -eq 0 ]; then
        export PS1="${PS1}\\[\\033[1;32m\\]"
    else
        export PS1="${PS1}\\[\\033[1;31m\\]"
    fi
    export PS1="${PS1}\\$\\[\\033[00m\\] "
}

export PROMPT_COMMAND=prompt_command