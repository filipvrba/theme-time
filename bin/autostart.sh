#!/bin/bash

file="theme_time.desktop"

cat << EOF >> ~/.config/autostart/$file
[Desktop Entry]
Type=Application
Name=Theme Time
Exec=tt
Terminal=false
EOF
echo "A '$file' be created to config for autostart."
