#!/bin/sh

# Stub to compile packages that refuse to build without gettext.

gcc -shared -fpic -o libintl.so libintl-stub.c &&
install -m 755 libintl.so /usr/lib && 
install -m 644 libintl-stub.h /usr/include/libintl.h &&
install -m 755 msgfmt /usr/bin
