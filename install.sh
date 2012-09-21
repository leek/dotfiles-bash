#!/bin/bash -e
cd

UNAME=$(uname)
DOTFILES="$HOME/dotfiles"
BACKUP_TIME="$(date +%Y%m%d_%H%M%S)"
POSITIVE=0
NEGATIVE=1
NEUTRAL=2

source $DOTFILES/lib/colors.bash
source $DOTFILES/lib/colorful.bash
source $DOTFILES/functions/available/default.bash

#
# Functions
#

function _df_echo_file_status() {
    local filename="$(basename $2)"
    local message=${3:-}
    if [[ $1 == $POSITIVE ]]; then
        echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename $message${echo_reset_color}"
    elif [[ $1 == $NEGATIVE ]]; then
        echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename $message${echo_reset_color}"
    elif [[ $1 == $NEUTRAL ]]; then
        echo -e " ${echo_bold_black}${SYMBOL_NEUTRAL} ${echo_cyan}$filename $message${echo_reset_color}"
    fi
}

function _df_make_backup() {
    local filepath=$1
    local filename="$(basename $filepath)"
    local filepath_backup="${filepath}_${BACKUP_TIME}"
    if [[ ! -e $filepath_backup ]]; then
        if [[ -e $filepath ]]; then
            cp -R "$filepath" "$filepath_backup"
            if [[ -e $filepath_backup ]]; then
                _df_echo_file_status $POSITIVE $filepath
                return
            fi
        else
            _df_echo_file_status $NEUTRAL $filepath
            return
        fi
    fi
    _df_echo_file_status $NEGATIVE $filepath
}

function _df_install_to_home() {
    local filepath=$1
    local filename="$(basename $filepath)"
    if [[ -e $filepath ]]; then
        if [[ -e "$HOME/$filename" ]]; then
            if [[ -L "$HOME/$filename" ]]; then
                # Link already exists
                _df_echo_file_status $NEUTRAL $filepath "\033[1;30m(Link already exists)"
                return
            else
                if [[ $BACKUP_FILES == 1 ]]; then
                    _df_make_backup $filepath
                else
                    _df_echo_file_status $NEGATIVE $filepath
                    return
                fi
            fi
        fi
        if [[ $CREATE_LINKS == 1 ]]; then
            (cd $HOME && ln -sF "$filepath")
            if [[ -L "$HOME/$filename" ]]; then
                _df_echo_file_status $POSITIVE $filepath
                return
            fi
        else
            cp -R "$filepath" $HOME
            if [[ -e "$HOME/$filename" ]]; then
                _df_echo_file_status $POSITIVE $filepath
                return
            fi
        fi
    fi
    _df_echo_file_status $NEGATIVE $filepath
}

function _df_enable_item() {
    local df_type="${1:-}"
    local df_item="${2:-}"
    local enabled_path="${DOTFILES}/${df_type}/enabled"
    local available_path="${DOTFILES}/${df_type}/available/${df_item}"
    local filename="$(basename $available_path)"
    if [[ -e "${enabled_path}/${filename}" ]]; then
        # Already enabled
        _df_echo_file_status $NEUTRAL $filepath "\033[1;30m(Item already enabled)"
        return
    fi
    if [[ -e $available_path ]]; then
        (cd $enabled_path && ln -sF "../available/${df_item}")
        if [[ -L "${enabled_path}/${filename}" ]]; then
            _df_echo_file_status $POSITIVE $filepath
            return
        fi
    fi
    _df_echo_file_status $NEGATIVE $filepath
}

#
# Config Questions
#

echo ""
echo -en "${echo_yellow}Make backups if file(s) already exist?${echo_reset_color}"
if ask "" Y; then
    BACKUP_FILES=1
else
    BACKUP_FILES=0
fi

echo ""
echo -en "${echo_yellow}Create symlinks instead of copies?${echo_reset_color}"
if ask "" Y; then
    CREATE_LINKS=1
else
    CREATE_LINKS=0
fi

_df_install_to_home "$DOTFILES/.bash_profile"
_df_install_to_home "$DOTFILES/.bashrc"

# Aliases, Completions, and Functions
for source_type in "aliases" "completions" "functions"; do
    # Install?
    echo ""
    echo -en "${echo_yellow}Enable all ${echo_bold_yellow}${echo_underline_yellow}$source_type${echo_yellow}?${echo_reset_color}"
    if ask "" Y; then
        rm -rf $DOTFILES/$source_type/enabled
        mkdir -p $DOTFILES/$source_type/enabled
        for filepath in $DOTFILES/$source_type/available/*.bash; do
            filename="$(basename $filepath)"
            [[ -f $filepath ]] && _df_enable_item "$source_type" "$filename"
        done
        if [[ $UNAME == "Darwin" ]]; then
            for filepath in $DOTFILES/$source_type/available/osx/*.bash; do
                filename="$(basename $filepath)"
                [[ -f $filepath ]] && _df_enable_item "$source_type" "osx/$filename"
            done
        elif [[ $UNAME == "Linux" ]]; then
            for filepath in $DOTFILES/$source_type/available/linux/*.bash; do
                filename="$(basename $filepath)"
                [[ -f $filepath ]] && _df_enable_item "$source_type" "linux/$filename"
            done
        fi
    fi
done

cd

# rc-files
echo ""
echo -en "${echo_yellow}Install rc-files?${echo_reset_color}"
if ask "" Y; then
    for filepath in $DOTFILES/rc-files/.*; do
        filename="$(basename $filepath)"
        if [[ $filename == ".gemrc" ]]; then
            if type "gem" &> /dev/null; then
                _df_echo_file_status $NEUTRAL "${filename}"
                continue
            fi
        elif [[ $filename == ".npmrc" ]]; then
            if type "npm" &> /dev/null; then
                _df_echo_file_status $NEUTRAL "${filename}"
                continue
            fi
        elif [[ $filename == ".mongorc.js" ]]; then
            if type "mongo" &> /dev/null; then
                _df_echo_file_status $NEUTRAL "${filename}"
                continue
            fi
        fi
        [[ -f $filepath ]] && _df_install_to_home "$filepath"
    done
    if [[ $UNAME == "Darwin" ]]; then
        for filepath in $DOTFILES/rc-files/osx/.*; do
            [[ -f $filepath ]] && _df_install_to_home "$filepath"
        done
    elif [[ $UNAME == "Linux" ]]; then
        for filepath in $DOTFILES/rc-files/linux/.*; do
            [[ -f $filepath ]] && _df_install_to_home "$filepath"
        done
    fi
fi

# Git files
echo ""
echo -en "${echo_yellow}Install Git related files?${echo_reset_color}"
if ask "" Y; then
    for filepath in $DOTFILES/resources/.git*; do
        filename="$(basename $filepath)"
        if [[ $filename == '.gitconfig' ]]; then
            # Copy .gitconfig instead of link so we can add usernames/etc
            if [[ ! -e $filepath ]]; then
                cp -R "$filepath" .
            else
                _df_echo_file_status $NEUTRAL "${filename}"
            fi
        else
            _df_install_to_home "$filepath"
        fi
    done
fi

# Scripts/Binaries
echo ""
echo -en "${echo_yellow}Install commands/scripts?${echo_reset_color}"
if ask "" Y; then
    sourcepath=$DOTFILES/resources/scripts
    destpath=/usr/local/bin
    for current in "ssh-copy-id" "service" "pidof"; do
        if [[ -e "${sourcepath}/${current}.sh" ]]; then
            if type "$current" &> /dev/null; then
                _df_echo_file_status $NEUTRAL "${current}"
            else
                ln -s "${sourcepath}/${current}.sh" "${destpath}/${current}" && chmod +x "${destpath}/${current}"
                if [[ -x "${destpath}/${current}" ]]; then
                    _df_echo_file_status $POSITIVE "${current}"
                else
                    _df_echo_file_status $NEGATIVE "${current}"
                fi
            fi
        fi
    done
fi

echo ""
echo -e "${echo_green}Done! ${echo_reset_color}"
echo ""
