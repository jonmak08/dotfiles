#!/bin/sh

echo 'Cloning Git repositories...'

# Make workspace directory
[[ ! -d "${HOME}/workspace" ]] && mkdir -p "${HOME}/workspace"

echo 'Git repositories setup complete.'
