#!/bin/bash

VERSIONS=(`cat VERSIONS | xargs`)

for VERSION in ${VERSIONS[@]}; do
  mkdir tmp
  cd tmp
  echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json
  npm install
  if [ $? -eq 0 ]; then
    FILENAME="tsc-v${VERSION}.sha256"
    sha256sum -b node_modules/typescript/bin/tsc > ../resources/$FILENAME
  fi
  cd ../
  rm -rf tmp/
done