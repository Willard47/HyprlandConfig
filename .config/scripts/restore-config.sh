#!/usr/bin/env bash
rsync -avh $1 ~/.config/
echo "Restore complete from $1"
