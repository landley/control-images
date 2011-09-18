#!/bin/bash

# Control image generation infrastructure using common bootstrap files.

# Copy common infrastructure to target

cp "$TOP/common/"{utility_functions.sh,bootstrap/*} "$WORK" || exit 1
if [ -e "$MYDIR/mnt" ]
then
  cp -a "$MYDIR/mnt/." "$WORK" || exit 1
fi

# Put package cache in the control image, so the target system image can
# build from this source.

SRCTREE="$WORK/packages" &&
mkdir "$SRCTREE" &&
announce "Download/extract source code" &&
EXTRACT_ALL=1 source "$MYDIR"/download.sh || exit 1

cleanup_oldfiles
