#!/bin/bash

export HOME=/home/${NB_USER}
echo "Running hook to prepare home directory: ${HOME}"

if [ ! -f ${HOME}/.profile ]; then
   echo "Adding .profile"
   if [ "$(id -u)" == 0 ]; then
      su -c "cp /etc/skel/.profile ${HOME}/." ${NB_USER}
   else
      cp /etc/skel/.profile ${HOME}/.
   fi
fi

if [ ! -f ${HOME}/.bash_logout ]; then
   echo "Adding .bash_logout"
   if [ "$(id -u)" == 0 ]; then
      su -c "cp /etc/skel/.bash_logout ${HOME}/." ${NB_USER}
   else
      cp /etc/skel/.bash_logout ${HOME}/.
   fi
fi

if [ ! -f ${HOME}/.bashrc ]; then
   echo "Adding .bashrc"
   if [ "$(id -u)" == 0 ]; then
      su -c "cp /etc/skel/.bashrc ${HOME}/." ${NB_USER}
      su -c "conda init" ${NB_USER}
   else
      cp /etc/skel/.bashrc ${HOME}/.
      conda init
   fi
fi

echo "Finished hook to prepare home directory: ${HOME}"

