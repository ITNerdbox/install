#!/bin/bash
clear

VERSION=`vmware -v | cut -d " " -f 3`
echo "------------------------------------------"
echo "  VMWare Workstation Host Module Patcher  "
echo "------------------------------------------"
echo "[+] Detect VMWare version $VERSION"

if [ "$EUID" -ne 0 ]
  then echo "[!] Root privileges are required"
  exit
fi


VMWARE_VERSION=workstation-$VERSION
VMWARE_TEMPDIR=/tmp/vmware-patch

rm -fdr $VMWARE_TEMPDIR
mkdir -p $VMWARE_TEMPDIR
cd $VMWARE_TEMPDIR

echo "[+] Downloading VMWare host modules"
git clone https://github.com/mkubecek/vmware-host-modules.git &> /dev/null
cd $VMWARE_TEMPDIR/vmware-host-modules
git checkout $VMWARE_VERSION &> /dev/null
git fetch &> /dev/null
echo "[+] Compiling VMWare host modules"
make &> /dev/null
make install &> /dev/null
rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
ln -s /lib/x86_64-linux-gnu/libz.so.1 /usr/lib/vmware/lib/libz.so.1/libz.so.1
echo "[+] Restarting VMWare daemon"
/etc/init.d/vmware restart &> /dev/null
echo "[+] Patch done!"
