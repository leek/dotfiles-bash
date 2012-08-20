#!/bin/bash -e
cd

[ -d .dotfiles ] || git clone git://github.com/leek/dotfiles.git .dotfiles
(
    set -e
    cd .dotfiles

    TEMPFILE="`mktemp -t install.XXXXXX`"
    trap '{ rm -f "$TEMPFILE"; }' EXIT
)

cd

CURRENT=`pwd`
DOTFILES="${CURRENT}/.dotfiles"
BACKUP_TIME="$(date +%Y%m%d_%H%M%S)"

# So we have colors available
source $DOTFILES/lib/colors.bash
source $DOTFILES/lib/colorful.bash
source $DOTFILES/functions/available/default.bash

#
# Functions
#

function _df_echo_file_status() {
    local filename="$(basename $2)"
    local reason=${3:-}
    if [[ $1 == 'POSITIVE' ]]; then
        echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename $reason${echo_reset_color}"
    elif [[ $1 == 'NEGATIVE' ]]; then
        echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename $reason${echo_reset_color}"
    else
        echo -e " ${echo_bold_black}${SYMBOL_NEUTRAL} ${echo_cyan}$filename $reason${echo_reset_color}"
    fi
}

function _df_make_backup() {
    local filepath=$1
    local filename="$(basename $filepath)"
    local filepath_backup="${filepath}_${BACKUP_TIME}"
    echo ""
    echo -e "Backing up ${echo_bold_white}$filename${echo_reset_color}..."
    if [[ -e $filepath_backup ]]; then
        _df_echo_file_status "NEGATIVE" "$filepath_backup"
    else
        if [[ -e $filepath ]]; then
            cp -R "$filepath" "$filepath_backup"
            if [[ -e $filepath_backup ]]; then
                _df_echo_file_status "POSITIVE" "$filename"
            else
                _df_echo_file_status "NEGATIVE" "$filepath_backup"
            fi
        else
            _df_echo_file_status "NEUTRAL" "$filename"
        fi
    fi
}

function _df_install_to_home() {
    local filepath=$1
    local filename="$(basename $filepath)"
    if [[ ! -e $filepath ]]; then
        if [[ $CREATE_LINKS == 1 ]]; then
            ln -sF "$filepath"
            if [[ -L $filename ]]; then
                _df_echo_file_status "POSITIVE" "$filename"
            else
                _df_echo_file_status "NEGATIVE" "$filename"
            fi
        else
            cp -R "$filepath" .
            if [[ -e $filename ]]; then
                _df_echo_file_status "POSITIVE" "$filename"
            else
                _df_echo_file_status "NEGATIVE" "$filename"
            fi
        fi
    else
        _df_echo_file_status "NEUTRAL" "$filename"
    fi
}

function _df_enable_item() {
    local filename="$(basename $2)"
    local enabledpath="$DOTFILES/$1/enabled/$filename"
    local availpath="$DOTFILES/$1/available/$2"
    if [[ ! -e $enabledpath ]] && [[ -e $availpath ]]; then
        ln -sF "$availpath" "$enabledpath"
        if [[ -L $enabledpath ]]; then
            _df_echo_file_status "POSITIVE" "$filename"
        else
            _df_echo_file_status "NEGATIVE" "$filename"
        fi
    else
        _df_echo_file_status "NEUTRAL" "$filename"
    fi
}

#
# Config Questions
#

echo ""
echo -en "${echo_yellow}Make backups if file(s) already exist?${echo_reset_color}"
if ask "" N; then
    BACKUP_FILES=1
    df_make_backup ".bash_profile"
else
    BACKUP_FILES=0
    _df_echo_file_status "NEUTRAL" ".bash_profile"
fi

echo ""
echo -en "${echo_yellow}Create symlinks instead of copies?${echo_reset_color}"
if ask "" Y; then
    CREATE_LINKS=1
else
    CREATE_LINKS=0
fi

_df_install_to_home "$DOTFILES/.bash_profile"

# Aliases, Completions, and Functions
for source_type in "aliases" "completions" "functions"; do
    # Install?
    echo ""
    echo -en "${echo_yellow}Enable all ${echo_bold_yellow}${echo_underline_yellow}$source_type${echo_yellow}?${echo_reset_color}"
    if ask "" Y; then
        mkdir -p $DOTFILES/$source_type/enabled
        for filepath in $DOTFILES/$source_type/available/*.bash; do
            filename="$(basename $filepath)"
            [[ -f $filepath ]] && _df_enable_item "$source_type" "$filename"
        done
        if [[ is_mac ]]; then
            for filepath in $DOTFILES/$source_type/available/osx/*.bash; do
                filename="$(basename $filepath)"
                [[ -f $filepath ]] && _df_enable_item "$source_type" "osx/$filename"
            done
        else
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
        [[ -f $filepath ]] && _df_install_to_home "$filepath"
    done
    if [[ is_mac ]]; then
        for filepath in $DOTFILES/rc-files/osx/.*; do
            [[ -f $filepath ]] && _df_install_to_home "$filepath"
        done
    else
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
            if [[ ! -e $filepath ]]; then
                cp -R "$filepath" .
            else
                _df_echo_file_status "NEUTRAL" "${filename}"
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
    for current in "ssh-copy-id" "service" "magento"; do
        if [[ -e "${sourcepath}/${current}.sh" ]]; then
            if [[ ! -x "$(which ${current})" ]]; then
                ln -s "${sourcepath}/${current}.sh" "${destpath}/${current}" && chmod +x "${destpath}/${current}"
                if [[ -x "${destpath}/${current}" ]]; then
                    _df_echo_file_status "POSITIVE" "${current}"
                else
                    _df_echo_file_status "NEGATIVE" "${current}"
                fi
            else
                _df_echo_file_status "NEUTRAL" "${current}"
            fi
        fi
    done
fi

echo ""
echo -e "${echo_green}Done! ${echo_reset_color}"
echo ""
