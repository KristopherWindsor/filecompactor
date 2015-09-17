#!/bin/bash

# This script works on each file in a directory.
# It stores the file in a datastore (where no file will be stored twice),
# then replaces the original file with a symlink to the file in the datastore.
#
# To run this script:
#   $ ./filecompactor.sh <path to store> <path of store>
#   $ ./filecompactor.sh /my/files /my/datastore

function workOnFile(){
  local fileName=$1
  local toDir=$2

  hash=`getHashOfFile "$fileName"`
  if [ ! -f "$toDir/$hash" ]; then
    cp "$fileName" "$toDir/$hash"
  fi
}

# abstract md5 command because it is platform specific
function getHashOfFile(){
  local fileName=$1
  md5 -q "$fileName"
}

function main(){
  local fromDir=${1%/}
  local toDir=${2%/}

  if [ ! -d "$fromDir" ]; then
    echo "$fromDir not a directory"
    exit 1
  fi

  if [ ! -d "$toDir" ]; then
    echo "$toDir not a directory"
    exit 1
  fi

  find "$fromDir" -type f | while read line; do
    workOnFile "$line" "$toDir"
  done
}

main "$@"

