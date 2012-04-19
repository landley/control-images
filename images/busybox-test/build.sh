#!/bin/bash

# Run the busybox test suite.

EXTRACT_ALL=1

URL=http://www.busybox.net/downloads/busybox-1.19.4.tar.bz2 \
SHA1=5d7db83d8efbadc19c86ec236e673504bbf43517 \
maybe_fork "download || dienow"

cat > "$WORK"/init << 'EOF' || dienow
#!/bin/bash

echo === $HOST Run busybox test suite

cp -sfR /mnt/busybox busybox && cd busybox &&
make defconfig &&
make -j $CPUS &&
cd testsuite &&
./runtest &&
cd .. &&
rm -rf busybox || exit 1

sync

EOF
chmod +x "$WORK"/init || dienow
