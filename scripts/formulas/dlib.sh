#! /bin/bash
#
# DLIB
#
# uses CMake

# define the version
VER=19.4

# tools for git use
GIT_URL="https://github.com/davisking/dlib"
#GIT_TAG="v$VER"
GIT_TAG=

FORMULA_TYPES=( "osx" "android" "linux64")


# download the source code and unpack it into LIB_NAME
function download() {
	curl -Lk http://dlib.net/files/dlib-$VER.tar.bz2 -o dlib-$VER.tar.bz2
	tar -xjvf dlib-$VER.tar.bz2
	mv dlib-$VER dlib
	rm dlib-$VER.tar.bz2
}

# prepare the build environment, executed inside the lib src dir
function prepare() {
   	if [ "$TYPE" == "android" ] ; then
   		cp -rf $FORMULA_DIR/jni/  jni
	fi
}

# executed inside the lib src dir
function build() {
	echo "++++++"
	pwd

	if [ "$TYPE" == "osx" ] || [ "$TYPE" == "linux64" ] ; then

		cd dlib
		mkdir -p build
		cd build

		export MAKEFLAGS="-j$PARALLEL_MAKE -s"

		echo "-----------------------"
		pwd

		cmake -D DLIB_NO_GUI_SUPPORT=yes -D CMAKE_INSTALL_PREFIX=$LIBS_DIR/dlib/install ..
		cmake --build . --config Release

		pwd

		cd ../../
	elif [ "$TYPE" == "android" ] ; then
		${NDK_ROOT}/ndk-build -j4 NDK_DEBUG=0 NDK_PROJECT_PATH=.
	fi
}

# executed inside the lib src dir, first arg $1 is the dest libs dir root
function copy() {
	echo "COPYING ..."
	echo $1
	echo $BUILD_DIR
	# headers

	if [ -d $1/include ]; then
		rm -rf $1/include
	fi

	mkdir -p $1/include
	mkdir -p $1/lib/$TYPE

	if [ "$TYPE" == "osx" ] || [ "$TYPE" == "linux64" ] ; then
		cd $BUILD_DIR/dlib/dlib/build
		make install
		cd -
		mv $1/install/lib/libdlib.a $1/lib/$TYPE/
		mv $1/install/include/dlib $1/include/
		rm -r $1/install

		# rm -rf $1/share
		# cp $
		# mv $1/lib $1/lib_
		# mkdir -p $1/lib
		# cp $1/lib_/libdlib.a $1/lib/libdlib.a
		# cp -r dlib/ $1/include/dlib
		# rm -rf $1/include/dlib/build
		# rm -rf $1/include/dlib/test
		# rm  $1/include/dlib/all_gui.cpp
		# ls -la dlib/build
		# echo $1
		# mkdir -p $1/lib/osx/
		#cp dlib/build/libdlib.a $1/lib/osx/libdlib.a
	elif [ "$TYPE" == "android" ] ; then
		cp -vr dlib/ $1/include/dlib
		rm -rf $1/include/dlib/build
		rm -rf $1/include/dlib/test
		rm  $1/include/dlib/all_gui.cpp

		cp -vr obj/local/armeabi-v7a/libdlib.a $1/lib/android/armeabi-v7a/libdlib.a
		cp -vr obj/local/x86/libdlib.a $1/lib/android/x86/libdlib.a
	fi
}

# executed inside the lib src dir
function clean() {
	if [ "$TYPE" == "osx" ] || [ "$TYPE" == "linux64" ] ; then
		cd dlib/build
		cmake clean .
		cd ..
		rm -rf build
		cd ..
	elif [ "$TYPE" == "android" ] ; then
		rm -rf obj
	fi



}