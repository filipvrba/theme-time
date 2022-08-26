#!/bin/bash

abspath=$(realpath $0)
binpath=${abspath%/*}
runpath=$binpath/run.sh

ln -s $runpath ~/.local/bin/tt &&
echo "Link by created under name 'tt'."

ln -s ~/.rvm/rubies/default/bin/ruby ~/.local/bin/ruby &&
echo "Link by created under name 'ruby'."
