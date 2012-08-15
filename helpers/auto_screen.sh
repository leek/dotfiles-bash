#!/bin/bash

# Auto-screen Support (http://taint.org/wk/RemoteLoginAutoScreen)
# Put in ~/.bashrc

if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]; then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
  sleep 1
  screen -RR && exit 0
  # Normally, execution of this rc script ends here...
  echo "Screen failed! continuing with normal bash startup"
fi
