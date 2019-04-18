#!/bin/sh

if [ -d /root/.elm ]; then
  rm -rf /root/.elm
fi
if [ -d /app/elm-stuff ]; then
  rm -rf /app/elm-stuff
fi

yarn install
./bin/webpack-dev-server
