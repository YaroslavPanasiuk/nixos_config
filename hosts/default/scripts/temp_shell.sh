#!/bin/sh
nix-store --gc
nix-collect-garbage -d
nix-store --gc

