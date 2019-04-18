#!/bin/sh

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

yarn install
bin/rails db:version && bin/rails db:migrate || bin/rails db:setup

bin/rails s -p 3000 -b '0.0.0.0'
