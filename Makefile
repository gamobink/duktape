#
#  Convenience Makefile; SCons is used for the actual build
#

.PHONY: default all clean test install

DIST_FILES =	\
	README.txt \
	LICENSE.txt \
	SConstruct \
	runtests/runtests.js \
	runtests/package.json \
	testcases/*.js \
	src/SConscript \
	src/*.py \
	src/*.c \
	src/*.h \
	src/UnicodeData.txt \
	src/SpecialCasing.txt \
	doc/SConscript

default:	all

all:
	scons -s -j 8

clean:
	scons -c -s

test:
	node runtests/runtests.js --run-duk --cmd-duk=$(shell pwd)/build/400/duk.400 --run-nodejs --run-rhino --num-threads 8 --log-file=/tmp/duk-test.log testcases/

vgtest:
	node runtests/runtests.js --run-duk --cmd-duk=$(shell pwd)/build/400/duk.400 --run-nodejs --run-rhino --num-threads 1 --log-file=/tmp/duk-vgtest.log --valgrind testcases/
	
install:
	scons -j 8 install

VERSION=0.1.0

dist-src:
	-rm -rf duktape-$(VERSION)/
	-rm -rf dist.tar.lzma
	mkdir duktape-$(VERSION) duktape-$(VERSION)/testcases duktape-$(VERSION)/src duktape-$(VERSION)/doc
	cp -r --parents $(DIST_FILES) duktape-$(VERSION)/
	tar cvfj duktape-$(VERSION).tar.bz2 duktape-$(VERSION)/
	mkisofs -o duktape-$(VERSION).iso duktape-$(VERSION).tar.bz2

