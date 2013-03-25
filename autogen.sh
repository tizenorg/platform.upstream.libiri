#! /bin/sh
srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
cd $srcdir

mkdir -p autotools
libtoolize --force || exit 1
aclocal -I autotools || exit 1
autoheader || exit 1
automake --add-missing --copy || exit 1
autoconf || exit 
configure --prefix=$PREFIX
$srcdir/configure $AUTOGEN_CONFIGURE_ARGS "$@" || exit $?
