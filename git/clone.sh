#!/bin/sh

echo 'Cloning Git repositories...'

# Make workspace directory
[[ ! -d "${HOME}/workspace" ]] && mkdir -p "${HOME}/workspace"

# Ardius
## https://github.com/ardiustech/mithrin
git clone git@github.com:ardiustech/mithrin.git ~/workspace/mithrin

# Gusto
## https://github.com/Gusto/config_files
git clone git@github.com:Gusto/config_files.git ~/workspace/config_files

# https://github.com/Gusto/zenpayroll
git clone git@github.com:Gusto/zenpayroll.git ~/workspace/zenpayroll


# Fetch submodule
git submodule update

echo 'Git repositories setup complete.'
