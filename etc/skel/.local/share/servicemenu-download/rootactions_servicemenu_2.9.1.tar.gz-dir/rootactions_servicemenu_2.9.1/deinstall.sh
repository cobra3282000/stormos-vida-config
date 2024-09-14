#!/bin/bash
KDE4PREFIX="$(kde4-config --path services | cut -d: -f1)"
if [ "x${KDE4PREFIX}" != "x" ]; then
   SERVICEMENUDIR4="${KDE4PREFIX}ServiceMenus/"
fi
KDE5PREFIX="$(kf5-config --path services | cut -d: -f1)"
if [ "x${KDE5PREFIX}" != "x" ]; then
   SERVICEMENUDIR5="${KDE5PREFIX}ServiceMenus/"
fi
FOLDERMENU="10-rootactionsfolders.desktop"
FILEMENU="11-rootactionsfiles.desktop"
SCRIPTFILE="rootactions-servicemenu.pl"
USRBINSCRIPTFILE="/usr/bin/"${SCRIPTFILE}
REMOVAL="1"

KDE4DATA="$(kde4-config --path data | cut -d: -f1)"
if [ "x${KDE4DATA}" != "x" ]; then
   DOWNLOADDIR4="${KDE4DATA}servicemenu-download/*rootactions_servicemenu.tar.gz-dir"
fi
KDE5DATA="$(kf5-config --path data | cut -d: -f1)"
if [ "x${KDE5DATA}" != "x" ]; then
   DOWNLOADDIR5="${KDE5DATA}servicemenu-download/*rootactions_servicemenu.tar.gz-dir"
fi

#check for script file installed in /usr/bin
if [ -f ${USRBINSCRIPTFILE} ]; then
   kdialog --yes-label "Remove it" --no-label "Leave it" --yesno "The script rootactions-servicemenu.pl was found in /usr/bin/.\n\nDo you wish to remove it (you may need to enter your admin password)?\n\nIt's a good idea to leave it if there are other users on your machine using the menu." 
   REMOVAL=$?
   if [ ${REMOVAL} -eq "254" ]; then # kdialog is pre 4.6 kde, without button label support
      kdialog --yesno "The script rootactions-servicemenu.pl was found in /usr/bin/.\n\nIt's a good idea to leave it if there are other users on your machine using the menu.\n\nRemove it? (you may need to enter your admin password)"
      REMOVAL=$?
   fi
fi

#remove existing files files installed in ServiceMenus
[ -f ${SERVICEMENUDIR4}${FOLDERMENU} ] && rm ${SERVICEMENUDIR4}${FOLDERMENU}
[ -f ${SERVICEMENUDIR4}${FILEMENU} ] && rm ${SERVICEMENUDIR4}${FILEMENU}
[ -f ${SERVICEMENUDIR4}${SCRIPTFILE} ] && rm ${SERVICEMENUDIR4}${SCRIPTFILE}
[ -f ${SERVICEMENUDIR5}${FOLDERMENU} ] && rm ${SERVICEMENUDIR5}${FOLDERMENU}
[ -f ${SERVICEMENUDIR5}${FILEMENU} ] && rm ${SERVICEMENUDIR5}${FILEMENU}
[ -f ${SERVICEMENUDIR5}${SCRIPTFILE} ] && rm ${SERVICEMENUDIR5}${SCRIPTFILE}


if [ $REMOVAL -eq "0" ]; then
   #SU command alternatives
   IKDESUDO="kdesudo -d --noignorebutton --"
   IKDESU="kdesu -d -c"
   IXDGSU="xdg-su -c"
   IKF5SU="$(kf5-config --path libexec)kf5/kdesu"
   ${IKDESUDO} "rm ${USRBINSCRIPTFILE}"
   EXITCODE=$?
   if [ ${EXITCODE} -eq "127" ]; then # no kdesudo installed, try kdesu
         ${IKDESU} "rm ${USRBINSCRIPTFILE}"
         EXITCODE=$?
       if [ ${EXITCODE} -eq "127" ]; then # no kdesu installed, try xdg-su
           ${IXDGSU} "rm ${USRBINSCRIPTFILE}"
           EXITCODE=$?
           if [ ${EXITCODE} -eq "127" ]; then # no xdg-su installed, try kf5-kdesu
                ${IKF5SU} "rm ${USRBINSCRIPTFILE}"
                EXITCODE=$?
           fi
       fi
   fi
   if [ ${EXITCODE} -ne "0" ]; then
      kdialog --error "Could not remove ${USRBINSCRIPTFILE}.\n\nPlease delete it manually to complete the uninstallation."   
   fi  
fi

[ -d ${DOWNLOADDIR4} ] && rm -r $DOWNLOADDIR4
[ -d ${DOWNLOADDIR5} ] && rm -r $DOWNLOADDIR5