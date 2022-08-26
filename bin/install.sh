#!/bin/bash

git submodule update --init &&
bin/linking.sh &&
bin/autostart.sh

echo
echo "Theme Time has been installed."
