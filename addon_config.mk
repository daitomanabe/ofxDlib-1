meta:
	ADDON_NAME = ofxDlib
	ADDON_DESCRIPTION = An dlib wrapper.
	ADDON_AUTHOR = Christopher Baker
	ADDON_TAGS = "computer vision" "machine learning"
	ADDON_URL = http://github.com/bakercp/ofxDlib

common:
	ADDON_CFLAGS = -O3 -Wno-strict-aliasing

	# Exclude includes and source.
	ADDON_SOURCES_EXCLUDE = libs/dlib/include/%
	ADDON_INCLUDES_EXCLUDE = libs/dlib/include/%

	# Manually add the includes and source.
	ADDON_INCLUDES = libs/dlib/include
	ADDON_INCLUDES += libs/ofxDlib/include
	ADDON_INCLUDES += src

osx:
	ADDON_LIBS = libs/dlib/lib/osx/libdlib.a

	# Clang has problems with deep, recursive templates.
	# https://github.com/davisking/dlib/issues/229
	# Increase the depth if needed.
	ADDON_CPPFLAGS += -ftemplate-depth=512

	# If your processor supports SIMD AVX instructions.
	ADDON_CPPFLAGS += -mavx

linux64:
	ADDON_LIBS = libs/dlib/lib/linux64/libdlib.a
	ADDON_PKG_CONFIG_LIBRARIES = libpng libjpeg

	# If your processor supports SIMD AVX instructions.
	ADDON_CPPFLAGS += -mavx

	# If dlib is compiled with libblas/liblapack support, you may need to include these.
	ADDON_PKG_CONFIG_LIBRARIES+=blas lapack

	# If dlib is compiled with CUDA support, you made need to include these.
	# ADDON_LDFLAGS+=-L/usr/local/cuda/lib64 -lcuda -lcudart -lcudnn -lcublas -lcurand -lcusolver

	# If dlib is compiled with MKL support, you may need to add an include here.
	# ADDON_INCLUDES+=/opt/intel/mkl/include

android/armeabi-v7a:
	ADDON_LIBS = libs/dlib/lib/android/armeabi-v7a/libdlib.a
	# If your processor supports SIMD NEON instructions.
	# ADDON_CPPFLAGS += -mfpu=neon

android/x86:
	ADDON_LIBS = libs/dlib/lib/android/x86/libdlib.a
	# If your processor supports SIMD AVX instructions.
	ADDON_CPPFLAGS += -mavx
