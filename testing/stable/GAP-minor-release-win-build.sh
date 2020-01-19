#!/bin/sh
#
# Building GAP Windows distribution in -win.zip format with Windows
# binaries for GAP and packages
# https://gap-ci.cs.st-andrews.ac.uk/job/GAP-minor-release-win-build/
#
source ./core_checkout_time.txt
unzip -q ${ARCHNAME}-nobin-win.zip
rm *.zip
rm -rf /cygdrive/c/${DISTNAME}
cp -r $DISTNAME /cygdrive/c/${DISTNAME}
rm -rf $DISTNAME
cd /cygdrive/c/${DISTNAME}
./autogen.sh
./configure
make

# extract GAP build settings like GAParch
source sysinfo.gap

# BUILDING PACKAGES

cd pkg
../bin/BuildPackages.sh
cat ./log/fail.log
# temporary removing binaries for ANUPQ and ACE
# see https://github.com/gap-system/gap/issues/1820
rm -rf anupq-*/bin
rm -rf ace-*/bin
cd ..

# END OF BUILDING PACKAGES

cd bin
sed -i 's/cygwin\\bin/'${DISTNAME}'\\bin\\'${GAParch}'/g' gap.bat
sed -i 's/cygwin\\bin/'${DISTNAME}'\\bin\\'${GAParch}'/g' gapcmd.bat
sed -i 's/cygwin\\bin/'${DISTNAME}'\\bin\\'${GAParch}'/g' gaprxvt.bat
cd ..

bin/instcygwinterminfo.sh
cp /bin/cyggcc_s-1.dll /bin/cyggmp-10.dll /bin/cygncursesw-10.dll /bin/cygpanelw-10.dll /bin/cygpopt-0.dll /bin/cygreadline7.dll /bin/cygstart.exe /bin/cygstdc++-6.dll /bin/cygwin1.dll /bin/mintty.exe /usr/bin/cygz.dll /usr/bin/rxvt.exe /usr/bin/regtool.exe /usr/i686-w64-mingw32/sys-root/mingw/bin/zlib1.dll bin/${GAParch}
cp /bin/cygcurl* /bin/cygidn* /bin/cygcrypto* /bin/cyggssapi* /bin/cyglber* /bin/cygldap* /bin/cygssh* /bin/cygssl* /bin/cygkrb* /bin/cygk5crypto* /bin/cygintl* /bin/cygcom_err* /bin/cygunistring* /bin/cygiconv* /bin/cygsasl* /bin/cygnghttp2* /bin/cygpsl* /bin/cygzmq* /bin/cygsodium* bin/${GAParch}
cd ..
zip -qq -r $WORKSPACE/${ARCHNAME}-win.zip ${DISTNAME}
cp $WORKSPACE/${ARCHNAME}-win.zip $WORKSPACE/gap-minor-win.zip
