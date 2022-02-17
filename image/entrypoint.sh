#!/bin/bash

if [ -z "$GIT_USER" ]; then
  echo "GIT_USER is required, please set it in your environment"
  exit 1
fi

if [ -z "$GIT_EMAIL" ]; then
  echo "GIT_EMAIL is required, please set it in your environment"
  exit 1
fi

if [ -z "$VNC_PASSWORD" ]; then
  echo "VNC_PASSWORD is required, please set it in your environment"
  exit 1
fi

# echo "Start OpenSSH Server ..."
sudo service ssh restart

if [ -f /etc/init.d/rsyslog ]; then
  # Reference: https://stackoverflow.com/questions/22526016/docker-container-sshd-logs
  # echo "Start Rsyslog(/var/log/auth.log) ..."
  if [ -f "/run/rsyslogd.pid" ]; then
    sudo rm -rf /run/rsyslogd.pid
  fi

  sudo service rsyslog restart
fi

if [ -f /etc/init.d/fail2ban ]; then
  # Reference: https://stackoverflow.com/questions/22526016/docker-container-sshd-logs
  # echo "Start Fail2ban(/var/log/fail2ban.log) ..."
  if [ -f "/var/run/fail2ban/fail2ban.sock" ]; then
    sudo rm -rf /var/run/fail2ban/fail2ban.sock
  fi

  sudo service fail2ban restart
fi

# Change Mirror
# bash /build/scripts/change-mirrors.sh

# Permission
# sudo chown -R $USER $HOME/.vnc
[ ! -d "$HOME/.vnc" ] && sudo mkdir -p $HOME/.vnc
sudo chown -R $USER $HOME/.vnc
#
[ ! -d "$HOME/code" ] && sudo mkdir -p $HOME/code
sudo chown -R $USER $HOME/code
#
[ ! -d "$HOME/.ssh" ] && sudo mkdir -p $HOME/.ssh
sudo chown -R $USER $HOME/.ssh
#
[ ! -d "$HOME/.vscode-server" ] && sudo mkdir -p $HOME/.vscode-server
sudo chown -R $USER $HOME/.vscode-server

# VNC Start
/build/vnc/vncserver.sh start

echo ""
echo "##################################"
echo "Now, Desktop Environment is Ready ..."
echo "##################################"
echo ""

sleep infinity
