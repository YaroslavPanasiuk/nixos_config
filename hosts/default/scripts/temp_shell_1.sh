#!/usr/bin/env bash

tempfile="/tmp/tempimage.png"
hyprshot -m region -o "/tmp" -f "tempimage.png"
qrrs -r $tempfile | wl-copy
