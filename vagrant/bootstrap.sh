#!/usr/bin/env bash

apt-get update
apt-get install -y curl
apt-get install -y libmysqlclient-dev
apt-get install -y make
apt-get install -y git
apt-get install -y vim
apt-get install -y nodejs
apt-get install -y libxslt-dev
apt-get install -y cifs-utils
apt-get install -y smbfs

curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install ruby

usermod -a -G rvm vagrant
gem install bundler -V