#!/bin/sh
#
# Build a fat binary on Mac OS X
#
# This script is based on fatbuild.sh from libsdl

# Number of CPUs (for make -j)
NCPU=`sysctl -n hw.ncpu`
if test x$NJOB = x; then
    NJOB=$NCPU
fi

# GCC Version to use goes here.
GCC_VERSION="4.2"
GCC_VERSION_PATCHLEVEL="4.2.1"

# Whether to build PPC binaries as well
BUILD_PPC=0

# Mac OS X SDK versions for 32-bit and 64-bit builds go here
SDK_VERSION_32="10.9"
SDK_VERSION_64="10.9"

# Generic configure flags you always want go here.
CONFIG_GENERIC="--disable-gmp"

# Generic, cross-platform CFLAGS you always want go here.
CFLAGS="-O3"

# PowerPC 32-bit configure flags (10.4 runtime compatibility)
CONFIG_PPC="--build=`uname -p`-apple-darwin --host=powerpc-apple-darwin"

# Path leading to /Developer
DEV_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform"
if [ ! -d "${DEV_PATH}" ]; then
	# SDKs for older version of XCode were placed in /Developer only
	DEV_PATH=""
fi

# Determine gcc and g++ path
GCC_PATH=`which gcc-${GCC_VERSION}`
if [ "x${GCC_PATH}" = x ]; then
	GCC_PATH=`which gcc`
fi
GCXX_PATH=`which g++-${GCC_VERSION}`
if [ "x${GCXX_PATH}" = x ]; then
	GCXX_PATH=`which g++`
fi

# PowerPC 32-bit compiler flags
CC_PPC="${GCC_PATH} -arch ppc"
CXX_PPC="${GCXX_PATH} -arch ppc"
CFLAGS_PPC="-mmacosx-version-min=10.4"
CPPFLAGS_PPC="-DMAC_OS_X_VERSION_MIN_REQUIRED=1040 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/System/Library/Frameworks \
-I${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/usr/lib/gcc/powerpc-apple-darwin11/${GCC_VERSION_PATCHLEVEL}/include \
-isystem /Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/usr/include"

# PowerPC 32-bit linker flags
LFLAGS_PPC="-arch ppc -Wl,-headerpad_max_install_names -mmacosx-version-min=10.4 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/System/Library/Frameworks \
-L${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/usr/lib/gcc/powerpc-apple-darwin11/${GCC_VERSION_PATCHLEVEL} \
-Wl,-syslibroot,${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk"

# PowerPC 64-bit configure flags (${SDK_VERSION_64} runtime compatibility)
CONFIG_PPC64="--build=`uname -p`-apple-darwin --host=powerpc-apple-darwin"

# PowerPC 64-bit compiler flags
CC_PPC64="${GCC_PATH} -arch ppc64"
CXX_PPC64="${GCXX_PATH} -arch ppc64"
CFLAGS_PPC64="-mmacosx-version-min=${SDK_VERSION_64}"
CPPFLAGS_PPC64="-DMAC_OS_X_VERSION_MIN_REQUIRED=1050 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/System/Library/Frameworks \
-I${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/lib/gcc/powerpc-apple-darwin11/${GCC_VERSION_PATCHLEVEL}/include \
-isystem ${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/include"

# PowerPC 64-bit linker flags
LFLAGS_PPC64="-arch ppc64 -Wl,-headerpad_max_install_names -mmacosx-version-min=${SDK_VERSION_64} \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/System/Library/Frameworks \
-L${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/lib/gcc/powerpc-apple-darwin11/${GCC_VERSION_PATCHLEVEL}/ppc64 \
-Wl,-syslibroot,${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk"

# Intel 32-bit configure flags (${SDK_VERSION_64} runtime compatibility)
CONFIG_X86="--build=`uname -p`-apple-darwin --host=i386-apple-darwin"

# They changed this to "darwin11" in Xcode 3.2 (Snow Leopard).
GCCUSRPATH_X86="${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/lib/gcc/i686-apple-darwin11/${GCC_VERSION_PATCHLEVEL}"
if [ ! -d "$GCCUSRPATH_X86" ]; then
    echo "Warning: Couldn't find any GCC usr path for x86"
	echo "Tried: $GCCUSRPATH_X86"
	echo "This is probably because we have Clang only. Proceeding with compilation..."
	GCCUSRPATH_X86_INCLUDE_DIR=""
	GCCUSRPATH_X86_LIB_DIR=""
else
	GCCUSRPATH_X86_INCLUDE_DIR="-I${GCCUSRPATH_X86}/include"
	GCCUSRPATH_X86_LIB_DIR="-L${GCCUSRPATH_X86}"
fi

# Intel 32-bit compiler flags
CC_X86="${GCC_PATH} -arch i386"
CXX_X86="${GCXX_PATH} -arch i386"
CFLAGS_X86="-mmacosx-version-min=10.4"
CPPFLAGS_X86="-DMAC_OS_X_VERSION_MIN_REQUIRED=1040 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/System/Library/Frameworks \
${GCCUSRPATH_X86_INCLUDE} \
-isystem ${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/usr/include"

# Intel 32-bit linker flags
LFLAGS_X86="-arch i386 -Wl,-headerpad_max_install_names -mmacosx-version-min=10.4 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk/System/Library/Frameworks \
${GCCUSRPATH_X86_LIB} \
-Wl,-syslibroot,${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_32}.sdk"

# Intel 64-bit configure flags (${SDK_VERSION_64} runtime compatibility)
CONFIG_X64="--build=`uname -p`-apple-darwin --host=i386-apple-darwin"

# Intel 64-bit compiler flags
CC_X64="${GCC_PATH} -arch x86_64"
CXX_X64="${GCXX_PATH} -arch x86_64"
CFLAGS_X64="-mmacosx-version-min=${SDK_VERSION_64}"
CPPFLAGS_X64="-DMAC_OS_X_VERSION_MIN_REQUIRED=1050 \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/System/Library/Frameworks \
-I${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/lib/gcc/i686-apple-darwin11/${GCC_VERSION_PATCHLEVEL}/include \
-isystem ${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/include"

# Intel 64-bit linker flags
LFLAGS_X64="-arch x86_64 -Wl,-headerpad_max_install_names -mmacosx-version-min=${SDK_VERSION_64} \
-F${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/System/Library/Frameworks \
-L${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk/usr/lib/gcc/i686-apple-darwin11/${GCC_VERSION_PATCHLEVEL}/x86_64 \
-Wl,-syslibroot,${DEV_PATH}/Developer/SDKs/MacOSX${SDK_VERSION_64}.sdk"

#
# Find the configure script
#
srcdir=`dirname $0`/..
auxdir=$srcdir/tools
cd $srcdir

#
# Figure out which phase to build:
# all,
# configure, configure-ppc, configure-ppc64, configure-x86, configure-x64
# make, make-ppc, make-ppc64, make-x86, make-x64, merge
# install
# clean
if test x"$1" = x; then
    phase=all
else
    phase="$1"
fi
case $phase in
    all)
		if [ $BUILD_PPC = 1 ]; then
			configure_ppc="yes"
			configure_ppc64="yes"
			make_ppc="yes"
			make_ppc64="yes"
		fi
		configure_x86="yes"
		configure_x64="yes"
        make_x86="yes"
        make_x64="yes"
        merge="yes"
        ;;
    configure)
		if [ $BUILD_PPC = 1 ]; then
			configure_ppc="yes"
			configure_ppc64="yes"
		fi
        configure_x86="yes"
        configure_x64="yes"
        ;;
    configure-ppc)
        configure_ppc="yes"
        ;;
    configure-ppc64)
        configure_ppc64="yes"
        ;;
    configure-x86)
        configure_x86="yes"
        ;;
    configure-x64)
        configure_x64="yes"
        ;;
    make)
		if [ $BUILD_PPC = 1 ]; then
			make_ppc="yes"
			make_ppc64="yes"
		fi
        make_x86="yes"
        make_x64="yes"
        merge="yes"
        ;;
    make-ppc)
        make_ppc="yes"
        ;;
    make-ppc64)
        make_ppc64="yes"
        ;;
    make-x86)
        make_x86="yes"
        ;;
    make-x64)
        make_x64="yes"
        ;;
    merge)
        merge="yes"
        ;;
    clean)
        clean_ppc="yes"
        clean_ppc64="yes"
        clean_x86="yes"
        clean_x64="yes"
        ;;
    clean-ppc)
        clean_ppc="yes"
        ;;
    clean-ppc64)
        clean_ppc64="yes"
        ;;
    clean-x86)
        clean_x86="yes"
        ;;
    clean-x64)
        clean_x64="yes"
        ;;
    *)
        echo "Usage: $0 [all|configure[-ppc|-ppc64|-x86|-x64]|make[-ppc|-ppc64|-x86|-x64]|merge|clean[-ppc|-ppc64|-x86|-x64]]"
        exit 1
        ;;
esac
case `uname -p` in
    powerpc)
        native_path=ppc
        ;;
    powerpc64)
        native_path=ppc64
        ;;
    *86)
        native_path=x86
        ;;
    x86_64)
        native_path=x64
        ;;
    *)
        echo "Couldn't figure out native architecture path"
        exit 1
        ;;
esac

#
# Create the build directories
#
for dir in fatbuild fatbuild/ppc fatbuild/ppc64 fatbuild/x86 fatbuild/x64; do
    if test -d $dir; then
        :
    else
        mkdir $dir || exit 1
    fi
done

#
# Build the PowerPC 32-bit binary
#
if test x$configure_ppc = xyes; then
    (cd fatbuild/ppc && \
     sh ../../configure $CONFIG_GENERIC $CONFIG_PPC CC="$CC_PPC" CXX="$CXX_PPC" CFLAGS="$CFLAGS $CFLAGS_PPC" CPPFLAGS="$CPPFLAGS_PPC" LDFLAGS="$LFLAGS_PPC") || exit 2
fi
if test x$make_ppc = xyes; then
    (cd fatbuild/ppc && ls src && make -j$NJOB) || exit 3
fi

#
# Build the PowerPC 64-bit binary
#
if test x$configure_ppc64 = xyes; then
    (cd fatbuild/ppc64 && \
     sh ../../configure $CONFIG_GENERIC $CONFIG_PPC64 CC="$CC_PPC64" CXX="$CXX_PPC64" CFLAGS="$CFLAGS $CFLAGS_PPC64" CPPFLAGS="$CPPFLAGS_PPC64" LDFLAGS="$LFLAGS_PPC64") || exit 2
fi
if test x$make_ppc64 = xyes; then
    (cd fatbuild/ppc64 && ls src && make -j$NJOB) || exit 3
fi

#
# Build the Intel 32-bit binary
#
if test x$configure_x86 = xyes; then
    (cd fatbuild/x86 && \
     sh ../../configure $CONFIG_GENERIC $CONFIG_X86 CC="$CC_X86" CXX="$CXX_X86" CFLAGS="$CFLAGS $CFLAGS_X86" CPPFLAGS="$CPPFLAGS_X86" LDFLAGS="$LFLAGS_X86") || exit 2
fi
if test x$make_x86 = xyes; then
    (cd fatbuild/x86 && make -j$NJOB) || exit 3
fi

#
# Build the Intel 32-bit binary
#
if test x$configure_x64 = xyes; then
    (cd fatbuild/x64 && \
     sh ../../configure $CONFIG_GENERIC $CONFIG_X64 CC="$CC_X64" CXX="$CXX_X64" CFLAGS="$CFLAGS $CFLAGS_X64" CPPFLAGS="$CPPFLAGS_X64" LDFLAGS="$LFLAGS_X64") || exit 2
fi
if test x$make_x64 = xyes; then
    (cd fatbuild/x64 && make -j$NJOB) || exit 3
fi

#
# Combine into fat binary
#
if test x$merge = xyes; then
    cd fatbuild
    output=.
    target=`find . -mindepth 4 -maxdepth 4 -type f -name '*.dylib' | head -1 | sed 's|.*/||'`
    (lipo -create -o $output/$target `find . -mindepth 4 -maxdepth 4 -type f -name "*.dylib"` &&
     ln -sf $target $output/libigraph.dylib &&
	 lipo -create -o $output/libigraph.a `find . -mindepth 4 -maxdepth 4 -type f -name "libigraph.a"` &&
     cp $native_path/src/.libs/libigraph.la $output &&
     cp $native_path/src/.libs/libigraph.lai $output) || exit 4
     echo "Build complete!"
     echo "Files can be found in the fatbuild directory."
    cd ..
fi

#
# Clean up
#
do_clean()
{
    echo $*
    $* || exit 6
}
if test x$clean_x86 = xyes; then
    do_clean rm -r build/x86
fi
if test x$clean_x64 = xyes; then
    do_clean rm -r build/x64
fi
if test x$clean_ppc = xyes; then
    do_clean rm -r build/ppc
fi
if test x$clean_ppc64 = xyes; then
    do_clean rm -r build/ppc64
fi

