#
# NAME
#   Makefile
#
# USAGE
#   make [all | downloads | software | stage | distribution ]
#
# DESCRIPTIONS
#   Top level makefile for the NOC package generation framework.  Don't touch
#   this file.  All local directives go in companion 'Makefile.local' file.
#
# NOTES
#   Most often you can build the software under your own ID, but you must be
#   root to stage software and buile packages.
#
# BUILD BOXEN:
#	az18u471	:32bit AIX 5.1 ppc	
#	az18u555	:32bit AIX 5.3 ppc
#	az18u555	:64bit AIX 5.3 ppc
#	de08u3623	:32bit AIX 6.1 ppc
#	de08u3623	:64bit AIX 6.1 ppc
#	az18u680	:Linux 64bit 2.6.9-42.ELsmp
#	az18u3071	:Linux 64bit 2.6.18-348.12.1.el5
#	az18u3071	:Linux 64bit 2.6.32-431.20.3.el6
#
# AUTHOR
#   Rick Swanson
#
#----------------------------------------------------------------------------
# $Id: Makefile 6 2012-11-15 22:05:32Z svwebadmin $
#----------------------------------------------------------------------------

export SHELL=/bin/bash
MOUNTDIR := $(shell echo `pwd` | cut -d'/' -f2)
LABEL := $(shell echo `pwd` | cut -d'/' -f3)
OSNAME := $(shell uname)
WHICHOS := $(shell uname -r)
MAJORNUM := $(shell uname -v)
MACHINE := $(shell uname -m)
REV := $(shell date +%Y%m%d)
include pkginfo

ifeq ($(OSNAME),SunOS)
  OSBITS := $(shell /usr/bin/isainfo -kv)
  ifeq ($(OSBITS),64)
    BITS=64
  endif
  SDK=/opt/SUNWspro
  OSVER=${WHICHOS}
  PROCESSOR := $(shell uname -p)
  CC=${SDK}/bin/cc
  CPPFLAGS=-I${LOCALOPT}/local/include -I${SDK}/include
  CFLAGS=-m64
  LDFLAGS=-Wl,-R${LOCALOPT}/local/lib${BITS},-L${LOCALOPT}/local/lib${BITS},-L${SDK}/lib
  COMPILER=solaris${OSBITS}-${PROCESSOR}v9-cc
endif

ifeq ($(OSNAME),AIX)
  SDK=/opt/freeware
  OSBITS := $(shell getconf -a | grep KERN | cut -f 2)
  OSVER=${MAJORNUM}.${WHICHOS}
  CC=${SDK}/bin/gcc
  CXX=${SDK}/bin/g++
  LDSHARED=${CC} -shared
  ifeq ($(OSBITS),64)
    ifeq ($(OBJECT_MODE),64)
      BITS=64
      OBJECT_MODE=64
    else
      OBJECT_MODE=32
    endif 
  endif
  LIBPATH=${LOCALOPT}/local/lib${BITS}:/usr/lib:/lib
  COMPILER=aix${BITS}-gcc
  CFLAGS=-maix${OBJECT_MODE} -O2 -pthread
  CXXFLAGS=${CFLAGS}
  CPPFLAGS=-I${LOCALOPT}/local/include -I/usr/include
  AR=/usr/bin/ar -X${OBJECT_MODE}
  NM=/usr/bin/nm -B -X${OBJECT_MODE}
  LDFLAGS=-Wl,-G,-bernotok,-bnolibpath
  export CC CXX LDSHARED COMPILER CFLAGS CXXFLAGS CPPFLAGS LIBPATH AR NM LDFLAGS OBJECT_MODE
endif

ifeq ($(OSNAME),Linux)
  OSBITS := $(shell getconf LONG_BIT)
  ifeq ($(OSBITS),64)
    BITS=64
  endif
  SDK=/usr
  OSVER=${WHICHOS}
  CC=${SDK}/bin/gcc
  CPPFLAGS=-I${LOCALOPT}/local/include
  LDFLAGS=-Wl,-R${LOCALOPT}/local/lib${BITS},-L${LOCALOPT}/local/lib${BITS}
  ifeq ($(OSBITS),64)
    COMPILER=linux-x86_64
    OBJECT_MODE=64
  else
    COMPILER=linux-elf
    OBJECT_MODE=32
  endif
  LD_LIBRARY_PATH=${LOCALOPT}/local/lib${BITS}:/usr/lib:/lib
  export LD_LIBRARY_PATH
endif

export CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS COMPILER OBJECT_MODE
include Makefile.local
VER := $(shell echo ${VERSION} | cut -d',' -f1)
SHORT_VER := $(shell echo ${VER} | sed -e 's/\.//' -e 's/\..*//')
BRANCH := $(shell echo ${VER} | cut -d'.' -f1,2)
OPT_STRING := $(shell echo ${LOCALOPT} | sed -e 's@/@@')
SPOOLDIR=\/var\/spool\/pkg
ARCHDIR=\/${MOUNTDIR}\/${LABEL}\/develop\/archive\/${OSNAME}${BITS}\/${OSVER}
SOURCEDIR=\/${MOUNTDIR}\/${LABEL}\/develop\/source
STAGEDIR=\/${MOUNTDIR}\/${LABEL}\/develop\/staged
THISDIR=${SOURCEDIR}\/${PKG}

all: software stage distribution
ifeq ($(OSNAME),SunOS)
  distribution: proto package bundle
else
  distribution: spec rpm
endif

#
# Check to make sure PKG variable is set.
#

chk:

	VERSION=${VERSION},REV=${REV}
	
	export PWD="`pwd`"
	if [ `whoami` == "root" ]; then \
	  echo; \
	  echo "  Don't run this is \"root\", knucklehead !!!" ;\
	  echo;\
	  exit 1; \
	fi

	if test ! "${PKG}" ; \
	then \
	    echo "\n\n\tPKG variable not set\n" ;\
	    exit 1 ; \
	fi

#
# Build the prototype file (Solaris)
#

proto: chk
	
	rm -f ${THISDIR}/prototype
	@ umask 0222 ; \
	touch prototype preinstall postinstall \
	preremove postremove request depend copyright README.${PKG}
	echo i pkginfo=pkginfo >> ${THISDIR}/prototype
	echo i preinstall=preinstall >> ${THISDIR}/prototype
	echo i postinstall=postinstall >> ${THISDIR}/prototype
	echo i preremove=preremove >> ${THISDIR}/prototype
	echo i postremove=postremove >> ${THISDIR}/prototype
	echo i request=request >> ${THISDIR}/prototype
	echo i depend=depend >> ${THISDIR}/prototype
	echo i copyright=copyright >> ${THISDIR}/prototype
	echo ""; echo "${CLASSES}"
	for name in ${CLASSES} ; \
	  do  \
	    echo "";  echo changing to directory ${THISDIR}/$${name};  cd ${THISDIR}/$${name}; \
	    echo creating prototype entries for class $${name}; \
	    for dir in `ls` ; \
	      do \
	        pkgproto -c $${name} `pwd`/$${dir}=$${dir} >> ${THISDIR}/prototype; \
	    done ; \
	done
	scripts/runsed.sh ${THISDIR} prototype ${THISDIR}/scripts/sedscripts/prototype.sed

#
# Build the directory format and datastream (Solaris)
#

package: chk
	
	pkgmk -o

#
# Bundle Package in a tar/gzip file (Solaris)
#

bundle: chk
	
	pkgtrans -s $(SPOOLDIR) $(ARCHDIR)/$(PKG)-$(VERSION)-$(ARCH)-$(OSVER)-$(OSBITS)bit.pkg $(PKG) 

#
# Create rpm package.spec file (AIX and Linux)
#

spec: chk
	
	--sudo ${SHELL} -c "rm -Rf ${THISDIR}/package.spec"
	echo "AutoReqProv: no" > ${THISDIR}/package.spec	
	echo "Name: ${NAME}-${OPT_STRING}-${OBJECT_MODE}bit" >> ${THISDIR}/package.spec
	echo "Version: `echo ${VERSION} | sed -e "s/,.*//"`" >> ${THISDIR}/package.spec
	echo "Release: `echo ${REV}`" >> ${THISDIR}/package.spec
	echo "Vendor: ${VENDOR}" >> ${THISDIR}/package.spec
	echo "Packager: ${EMAIL}" >> ${THISDIR}/package.spec
	echo "Summary: WebHosting bundling of ${NAME}" >> ${THISDIR}/package.spec
	echo "Group: Applications/WebHosting" >> ${THISDIR}/package.spec
	echo "License: GPL" >> ${THISDIR}/package.spec
	echo "Prefix: ${LOCALOPT}/local" >> ${THISDIR}/package.spec
	echo "%description" >> ${THISDIR}/package.spec
	echo "${NAME}" >> ${THISDIR}/package.spec
	echo "%files" >> ${THISDIR}/package.spec
	echo "`echo /`" >> ${THISDIR}/package.spec

#
# Create rpm distro (AIX and Linux)
#


rpm: chk spec
	
	--sudo ${SHELL} -c "install -d -m 755 -o root -g web ${ARCHDIR}"
	if [ "${OSNAME}" == "Linux" ] ; \
	  then \
	  sudo ${SHELL} -c "\
	    umask 000; \
	    rpmbuild -v -ba --buildroot "`echo ${STAGEDIR}/${PKG}`" --rmspec ${THISDIR}/package.spec --target ${MACHINE} > /tmp/rpmout.txt; \
	  "; \
	  sudo ${SHELL} -c "\
	    mv "`cat /tmp/rpmout.txt | grep 'Wrote: ' | grep -v 'SRPMS' | sed -e 's/Wrote: //'`" ${ARCHDIR}; \
	    echo; ls "${ARCHDIR}/`cat /tmp/rpmout.txt | grep 'Wrote: ' | grep -v 'SRPMS' | sed -e 's@.*/@@'`"; echo; \
	  "; \
	fi
	if [ "${OSNAME}" == "AIX" ] ; \
	  then \
	  sudo ${SHELL} -c "\
	    umask 002; \
	    rpm -v -ba --buildroot "`echo ${STAGEDIR}/${PKG}`" ${THISDIR}/package.spec ; \
	    mv /opt/freeware/src/packages/RPMS/ppc/${NAME}-${OPT_STRING}-${OBJECT_MODE}bit-`echo ${VERSION} | sed -e "s/,.*//"`-`echo ${REV}`.aix${OSVER}.ppc.rpm ${ARCHDIR}; \
            echo; ls ${ARCHDIR}/${NAME}-${OPT_STRING}-${OBJECT_MODE}bit-${VER}-${REV}.*; echo ; \
	  "; \
	fi

#
# Cleanup Routine
#

clean: chk
	
	@ # If PKG is not defined, we remove all contents of /var/spool/pkg
	@ # If both SPOOLDIR & PKG are defined, we scrub the system!
	--sudo ${SHELL} -c "rm -Rf /var/spool/pkg/${PKG}"
	--sudo ${SHELL} -c "rm -Rf ${STAGEDIR}/${PKG}"
	--sudo ${SHELL} -c "rm -Rf vendor"
	
#
# Housekeeping
#

veryclean: chk clean
	
	--sudo ${SHELL} -c "rm -Rf /var/spool/pkg/${PKG}"
	--sudo ${SHELL} -c "rm -Rf ${THISDIR}/source"
	--sudo ${SHELL} -c "rm -f ${THISDIR}/prototype"
	--sudo ${SHELL} -c "rm -f ${THISDIR}/package.spec"
	--sudo ${SHELL} -c "rm -f ${THISDIR}/${NAME}_*"

