#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

# Add to end of $PATH
path_push() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Prepend to beginning of $PATH
path_unshift() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Quick check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

#
# Dotfiles specific
#

function _df_load_enabled_by_type() {
    local path="$DOTFILES/$1/enabled"
    if [[ -d $path ]]; then
        for f in $path/*.bash; do
            [[ -e $f ]] && source $f
        done
    fi
}

function _df_enable_item() {
    local enabledpath="$DOTFILES/$1/enabled/$2"
    local availpath="$DOTFILES/$1/available/$2"
    if [[ ! -L "${enabledpath}" && ! -L "${enabledpath}.bash" ]]; then
        if [[ -x "${availpath}" ]]; then
            ln -sF "${availpath}" "${enabledpath}"
        elif [[ -x "${availpath}.bash" ]]; then
            ln -sF "${availpath}.bash" "${enabledpath}.bash"
        fi
    fi
}

function _df_disable_item() {
    local enabledpath="$DOTFILES/$1/enabled/$2"
    if [[ -L "${enabledpath}" ]]; then
        rm "${enabledpath}"
    elif [[ -L "${enabledpath}.bash" ]]; then
        rm "${enabledpath}.bash"
    fi
}

function df_reload_aliases() {
    _df_load_enabled_by_type "aliases"
}

function df_reload_completions() {
    _df_load_enabled_by_type "completions"
}

function df_reload_functions() {
    _df_load_enabled_by_type "functions"
}

function df_enable_alias() {
    _df_enable_item "aliases" "$1"
}

function df_enable_completion() {
    _df_enable_item "completions" "$1"
}

function df_enable_function() {
    _df_enable_item "functions" "$1"
}

function df_disable_alias() {
    _df_disable_item "aliases" "$1"
}

function df_disable_completion() {
    _df_disable_item "completions" "$1"
}

function df_disable_function() {
    _df_disable_item "functions" "$1"
}

function df_reload() {
    source ~/.bash_profile
}
