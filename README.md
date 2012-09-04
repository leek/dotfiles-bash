# ~/dotfiles

## Compiled from various sources/authors

* [bash-it](https://github.com/revans/bash-it)
* [jasoncodes](https://github.com/jasoncodes/dotfiles)
* [stehphenroller](https://github.com/stephenroller/dotfiles)
* [grosser](https://github.com/grosser/dotfiles)

## Installation

    cd ~/ && git clone git://github.com/leek/dotfiles.git && ./dotfiles/install.sh

## Extra

Also looks for ~/.dotfiles which can contain private dotfiles or overrides

### Reference

#### Bash Script Load Order

> **Source:** [http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/](Zsh/Bash startup files loading order)

    +----------------+-----------+-----------+------+
    |                |Interactive|Interactive|Script|
    |                |login      |non-login  |      |
    +----------------+-----------+-----------+------+
    |/etc/profile    |   A       |           |      |
    +----------------+-----------+-----------+------+
    |/etc/bash.bashrc|           |    A      |      |
    +----------------+-----------+-----------+------+
    |~/.bashrc       |           |    B      |      |
    +----------------+-----------+-----------+------+
    |~/.bash_profile |   B1      |           |      |
    +----------------+-----------+-----------+------+
    |~/.bash_login   |   B2      |           |      |
    +----------------+-----------+-----------+------+
    |~/.profile      |   B3      |           |      |
    +----------------+-----------+-----------+------+
    |BASH_ENV        |           |           |  A   |
    +----------------+-----------+-----------+------+
    |                |           |           |      |
    +----------------+-----------+-----------+------+
    |                |           |           |      |
    +----------------+-----------+-----------+------+
    |~/.bash_logout  |    C      |           |      |
    +----------------+-----------+-----------+------+
