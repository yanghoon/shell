#!/bin/bash

set -e

_usage () {
  echo "Filter namespaces list with grep options. and could execute any command with each namespace name"
  echo 
  echo "Usage:"
  echo "  $0 [grep options]"
  echo "  $0 [grep options] -- <command>"
  echo
  echo "  [grep options]  by passed as grep options"
  echo "  <command>       be executed by xargs with namespace name({})"
  echo "                  eg) ./$0 default -- kubectl get pod -n {}"
}

# variables
grep_opt=
command=

# - https://stackoverflow.com/a/402413
while [ $# -gt 0 ]
do
  case "$1" in
  (--) shift; command=$@; break;;
  (-h) _usage; exit 0;;
  (*)  grep_opt="$grep_opt $1";;
  esac
  shift
done

# Main
mem=$(kubectl get ns | tail -n +2)
mem=$(echo "$mem" | grep ${grep_opt:- -E '.*'})
mem=$(echo "$mem" | cut -f1 -d' ')

if [ -n "$command" ]; then
  echo "$mem" | xargs -i $command
else
  echo "$mem"
fi
