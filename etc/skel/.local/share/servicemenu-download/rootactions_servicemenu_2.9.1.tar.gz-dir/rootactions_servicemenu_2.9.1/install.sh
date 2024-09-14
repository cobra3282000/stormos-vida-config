#!/bin/bash
VERSION="2.9.1"
KDE4PREFIX="$(kde4-config --path services | cut -d: -f1)"
if [ "x${KDE4PREFIX}" != "x" ]; then
   SERVICEMENUDIR4="${KDE4PREFIX}ServiceMenus/"
fi
KDE5PREFIX="$(kf5-config --path services | cut -d: -f1)"
if [ "x${KDE5PREFIX}" != "x" ]; then
   SERVICEMENUDIR5="${KDE5PREFIX}ServiceMenus/"
fi
[ -z "${SERVICEMENUDIR4}" ] && [ -z "${SERVICEMENUDIR5}" ] && exit 2

SCRIPTDIR="$(dirname "$0")"
COPYTOUSRBIN="2"

#Installation confirmation
kdialog --yes-label "Install" --no-label "I'll do it manually" --cancel-label "Cancel installation" --yesnocancel "The script rootactions-servicemenu.pl needs to be installed in a directory in your \${PATH}.\n\nThe installer can install it automatically into /usr/bin/ (you may need to enter your admin password).\n\nYou can also choose to copy/move the script manually after the installation." 
COPYTOUSRBIN=$?
if [ ${COPYTOUSRBIN} -eq "254" ]; then # kdialog is pre 4.6 kde, without button label support
   kdialog --yesnocancel "The script rootactions-servicemenu.pl needs to be installed in a directory in your \${PATH}.\n\nThe installer can install it automatically into /usr/bin/ (you may need to enter your admin password).\n\nDo you wish to install to /usr/bin/?"
   COPYTOUSRBIN=$?
fi

if [ ${COPYTOUSRBIN} -eq "2" ]; then
   exit 1
fi

if [ "x${KDE4PREFIX}" != "x" ]; then
    [ -d ${SERVICEMENUDIR4} ] || mkdir -p ${SERVICEMENUDIR4}
    install -m 644 ${SCRIPTDIR}/Root_Actions_${VERSION}/dolphin-KDE4/*.desktop ${SERVICEMENUDIR4} || exit 1
else
    echo "No kde4 detected, skipping installation for kde4."
fi

if [ "x${KDE5PREFIX}" != "x" ]; then
    [ -d ${SERVICEMENUDIR5} ] || mkdir -p ${SERVICEMENUDIR5}
    install -m 644 ${SCRIPTDIR}/Root_Actions_${VERSION}/dolphin-KDE4/*.desktop ${SERVICEMENUDIR5} || exit 1
else
    echo "No kf5 detected, skipping installation for kf5."
fi

if [ ${COPYTOUSRBIN} -eq "1" ]; then
   if [ "x${KDE5PREFIX}" != "x" ]; then
      install -m 755 ${SCRIPTDIR}/Root_Actions_${VERSION}/rootactions-servicemenu.pl ${SERVICEMENUDIR5} || exit 1
      kdialog --msgbox "rootactions-servicemenu.pl was installed to:\n ${SERVICEMENUDIR5}.\n\n For the menu to work, you need to copy it manually into one of these directories:\n ${PATH}"
      exit 0
   else
      install -m 755 ${SCRIPTDIR}/Root_Actions_${VERSION}/rootactions-servicemenu.pl ${SERVICEMENUDIR4} || exit 1
      kdialog --msgbox "rootactions-servicemenu.pl was installed to:\n ${SERVICEMENUDIR4}.\n\n For the menu to work, you need to copy it manually into one of these directories:\n ${PATH}"
      exit 0
   fi
fi


if [ ${COPYTOUSRBIN} -eq "0" ]; then
   #SU command alternatives
   IKDESUDO="kdesudo -d --noignorebutton --"
   IKDESU="kdesu -d -c"
   IXDGSU="xdg-su -c"
   IKF5SU="$(kf5-config --path libexec)kf5/kdesu"
   SCRIPTINSTALL="install -m 755 ${SCRIPTDIR}/Root_Actions_${VERSION}/rootactions-servicemenu.pl /usr/bin/"
   ${IKDESUDO} "${SCRIPTINSTALL}" && exit 0
   EXITCODE=$?
   if [ ${EXITCODE} -eq "127" ]; then # no kdesudo installed, try kdesu
         ${IKDESU} "${SCRIPTINSTALL}" && exit 0
         EXITCODE=$?
       if [ ${EXITCODE} -eq "127" ]; then # no kdesu installed, try xdg-su
           ${IXDGSU} "${SCRIPTINSTALL}" && exit 0
           EXITCODE=$?
           if [ ${EXITCODE} -eq "127" ]; then # no xdg-su installed, try kf5-kdesu
                ${IKF5SU} "${SCRIPTINSTALL}" && exit 0
           fi          
       fi
   fi
   if [ "x${KDE5PREFIX}" != "x" ]; then
      install -m 755 ${SCRIPTDIR}/Root_Actions_${VERSION}/rootactions-servicemenu.pl ${SERVICEMENUDIR5} || exit 1
      kdialog --msgbox "rootactions-servicemenu.pl was installed to:\n ${SERVICEMENUDIR5}.\n\n For the menu to work, you need to copy it manually into one of these directories:\n ${PATH}"
      exit 0
   else
      install -m 755 ${SCRIPTDIR}/Root_Actions_${VERSION}/rootactions-servicemenu.pl ${SERVICEMENUDIR4} || exit 1
      kdialog --msgbox "rootactions-servicemenu.pl was installed to:\n ${SERVICEMENUDIR4}.\n\n For the menu to work, you need to copy it manually into one of these directories:\n ${PATH}"
      exit 0
   fi
fi
