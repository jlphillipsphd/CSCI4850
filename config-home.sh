#!/bin/bash

echo "Running hook to prepare home directory: ${HOME}"

if [ ! -f ${HOME}/.profile ]; then
   echo "Added .profile"
   su -c "cp /etc/skel/.profile ${HOME}/." ${NB_USER}
fi

if [ ! -f ${HOME}/.bash_logout ]; then
   echo "Added .bash_logout"
   su -c "cp /etc/skel/.bash_logout ${HOME}/." ${NB_USER}
fi

if [ ! -f ${HOME}/.bashrc ]; then
   echo "Added .bashrc"
   su -c "cp /etc/skel/.bashrc ${HOME}/." ${NB_USER}
   su -c "conda init" ${NB_USER}
fi
