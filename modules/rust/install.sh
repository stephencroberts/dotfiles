#!/bin/sh

mise use --global rust@latest

mise exec rust@latest -- rustup component add clippy
mise exec rust@latest -- rustup component add rust-analyzer
mise exec rust@latest -- rustup component add rustfmt
