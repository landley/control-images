#!/bin/bash

# Simple self-contained build control image creation script.  Doesn't use
# the bootstrap skeleton, instead compiles and runs the threaded "hello world"
# program from the Aboriginal Linux /usr/src directory as a build environment
# smoketest.  Grep the output for "Hello world!" to test for success.

# Download all the source tarballs we haven't got up-to-date copies of.

# The tarballs are downloaded into the "packages" directory, which is
# created as needed.

source common/include.sh || exit 1

# Write init script via a "here" document.

cat > "$WORK"/init << 'EOF' || dienow
#!/bin/bash

echo Started second stage init

cd /home &&
gcc -lpthread /usr/src/thread-hello2.c -o hello &&
./hello

# Upload our hello world file to the output directory (named hello-$HOST).
# No reason, just an example.

ftpput $FTP_SERVER -P $FTP_PORT hello-$HOST hello

sync

EOF

chmod +x "$WORK"/init || dienow

squash_image
