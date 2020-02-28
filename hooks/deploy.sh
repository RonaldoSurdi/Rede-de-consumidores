#!/bin/bash

source /home/consumer/.rvm/scripts/rvm

if [ -f /tmp/pid-consumer ]
then
    kill -9 `cat /tmp/pid-consumer` 2>/dev/null
fi

echo 'Bundle'
RAILS_ENV=production bundle -V

echo 'Pre Compile'
RAILS_ENV=production rake assets:precompile

echo 'Migrate'
RAILS_ENV=production rake db:migrate

echo 'Rails S'
rails server -e production --pid=/tmp/pid-consumer -d
