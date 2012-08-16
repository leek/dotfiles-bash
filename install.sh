#!/usr/bin/env bash -e
cd

[ -d .dotfiles ] || git clone git://github.com/leek/dotfiles.git .dotfiles
(
    set -e
    cd .dotfiles

    TEMPFILE="`mktemp -t install.XXXXXX`"
    trap '{ rm -f "$TEMPFILE"; }' EXIT
)

DOTFILES="$HOME/.dotfiles"

# So we have colors available
source $DOTFILES/includes/colors.bash
source $DOTFILES/includes/colorful.bash

# Do we want to make backups?
while true; do
    echo ""
    echo -en "${echo_yellow}Make backups? ${COLORED_YESNO}"
    read -p " " answer
    case $answer in
        [yY])
            BACKUP_FILES=1
            BACKUP_TIME="$(date +%Y%m%d_%H%M%S)"
            break
            ;;
        [nN])
            BACKUP_FILES=0
            break
            ;;
        *)
            echo -e "${echo_bold_red}Error! Please enter 'Y' or 'N'.${echo_reset_color}"
    esac
done

# Backup ~/.bash_profile
if [ $BACKUP_FILES == 1 ] && [ -f $HOME/$filename ]; then
    filename=$HOME/.bash_profile_$BACKUP_TIME
    echo ""
    echo -e "Backing up ${echo_bold_white}$HOME/.bash_profile${echo_reset_color}..."
    cp -R $HOME/.bash_profile $filename
    if [[ -f $HOME/.bash_profile_$BACKUP_TIME ]]; then
        echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename${echo_reset_color}"
    else
        echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename${echo_reset_color}"
        exit
    fi
fi

# Install ~/.bash_profile
echo ""
echo -e "Installing ${echo_bold_white}$DOTFILES/.bash_profile${echo_reset_color}..."
ln -sF $DOTFILES/.bash_profile $HOME/.bash_profile
echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$DOTFILES/.bash_profile${echo_reset_color}"

# Aliases, Completions, and Functions
for source_type in "aliases" "completions" "functions"; do
  while true; do
    dest="$DOTFILES/$source_type/enabled"
    mkdir -p $dest && cd $dest

    echo ""
    echo -en "${echo_yellow}Enable all ${echo_bold_yellow}${echo_underline_yellow}$source_type${echo_yellow}? ${COLORED_YESNO}"
    read -p " " answer
    case $answer in
        [yY])
            for source_file in $DOTFILES/$source_type/available/*; do
                filename="$(basename $source_file)"
                ln -sF $DOTFILES/$source_type/available/$filename $DOTFILES/$source_type/enabled/$filename
                echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename${echo_reset_color}"
            done
            break
            ;;
        [nN])
            for source_file in $DOTFILES/$source_type/available/*; do
                filename="$(basename $source_file)"
                echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename"
            done
            break
            ;;
        *)
            echo -e "${echo_bold_red}Error! Please enter 'Y' or 'N'.${echo_reset_color}"
    esac

    # Cleanup
    unset $source_file
    unset $answer
    unset $dest
  done
done

while true; do
    echo ""
    echo -en "${echo_yellow}Install rc-files? ${COLORED_YESNO}"
    read -p " " answer
    case $answer in
        [yY])
            for source_file in $DOTFILES/resources/rc-files/.*; do
                if [[ -f $source_file ]]; then
                    filename="$(basename $source_file)"
                    if [ $BACKUP_FILES == 1 ] && [ -f $HOME/$filename ]; then
                        cp -R $HOME/$filename $HOME/$filename_$BACKUP_TIME
                    fi
                    ln -sF $DOTFILES/resources/rc-files/$filename $HOME/$filename
                    echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename${echo_reset_color}"
                fi
            done
            break
            ;;
        [nN])
            for source_file in $DOTFILES/resources/rc-files/.*; do
                if [[ -f $source_file ]]; then
                    filename="$(basename $source_file)"
                    echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename"
                fi
            done
            break
            ;;
        *)
            echo -e "${echo_bold_red}Error! Please enter 'Y' or 'N'.${echo_reset_color}"
    esac
done

while true; do
    echo ""
    echo -en "${echo_yellow}Install Git related files? ${COLORED_YESNO}"
    read -p " " answer
    case $answer in
        [yY])
            for source_file in $DOTFILES/resources/.git*; do
                if [[ -f $source_file ]]; then
                    filename="$(basename $source_file)"
                    if [ $BACKUP_FILES == 1 ] && [ -f $HOME/$filename ]; then
                        cp -R $HOME/$filename $HOME/$filename_$BACKUP_TIME
                    fi
                    if [ $filename == '.gitconfig' ]; then
                        cp -R $DOTFILES/resources/$filename $HOME/$filename
                    else
                        ln -sF $DOTFILES/resources/$filename $HOME/$filename
                    fi
                    echo -e " ${echo_green}${SYMBOL_POSITIVE} ${echo_cyan}$filename${echo_reset_color}"
                fi
            done
            break
            ;;
        [nN])
            for source_file in $DOTFILES/resources/.git*; do
                if [[ -f $source_file ]]; then
                    filename="$(basename $source_file)"
                    echo -e " ${echo_red}${SYMBOL_NEGATIVE} ${echo_cyan}$filename"
                fi
            done
            break
            ;;
        *)
            echo -e "${echo_bold_red}Error! Please enter 'Y' or 'N'.${echo_reset_color}"
    esac
done

echo ""
echo -e "${echo_green}Done!${echo_reset_color}"
echo ""
