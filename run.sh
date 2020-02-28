#!/bin/bash

cd /home/consumer/

if [ -f /home/consumer/puma.pid ]
then
  kill `cat /home/consumer/puma.pid`
fi

if [ -f /home/consumer/sidekiq.pid ]
then
        kill `cat /home/consumer/sidekiq.pid`
fi

RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rake db:migrate

bundle exec puma -e production -d -b unix:///home/consumer/consumercard.sock --pidfile /home/consumer/puma.pid -t 1:6 -w 1
bundle exec sidekiq -d -e production -L /home/consumer/log/sidekiq.log -P /home/consumer/sidekiq.pid -c 5
