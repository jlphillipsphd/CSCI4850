#!/bin/bash

echo "Running hook to prepare home directory: ${HOME}"

if [ ! -f ~/.profile ]; then
   echo "Added .profile"
   su -c "cp /etc/skel/.profile ~/." ${NB_USER}
fi

if [ ! -f ~/.bash_logout ]; then
   echo "Added .bash_logout"
   su -c "cp /etc/skel/.bash_logout ~/." ${NB_USER}
fi

if [ ! -f ~/.bashrc ]; then
   echo "Added .bashrc"
   su -c "cp /etc/skel/.bashrc ~/." ${NB_USER}
   su -c "conda init" ${NB_USER}
fi

