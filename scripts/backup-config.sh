#!/usr/bin/env bash
DEST=~/HyprlandBackup_$(date +%Y%m%d_%H%M)
mkdir -p $DEST
rsync -avh ~/.config/ $DEST
echo "Backup complete: $DEST"
