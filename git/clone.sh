#!/bin/sh

echo 'Cloning Git repositories...'

# Make workspace directory
[[ ! -d "${HOME}/workspace" ]] && mkdir -p "${HOME}/workspace"

# Fetch submodule
git submodule update

echo 'Git repositories setup complete.'
