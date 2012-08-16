#!/usr/bin/env bash

function sshlist() {
  awk '$1 ~ /Host$/ { print $2 }' ~/.ssh/config
}
