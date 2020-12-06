#!/usr/bin/env bash

# Libx264 doesn't have any versioning system. Currently it has 2 branches: master and stable.
# Latest commit in stable branch
# Tue Jun 30 22:28:05 2020 +0300
LIBX264_VERSION=d198931a63049db1f2c92d96c34904c69fde8117

downloadTarArchive \
  "libx264" \
  "https://code.videolan.org/videolan/x264/-/archive/${LIBX264_VERSION}/x264-${LIBX264_VERSION}.tar.gz"
