#!/bin/bash

set -e

# function
usage () {
  echo ' Backup and restore replicas'
  echo 
  echo 'Usgae: '
  echo '  scale.sh dump <namespace> <kind>'
  echo '  scale.sh load <namespace> <kind>'
  echo '  scale.sh set  <namespace> <kind> <replicas>'
  echo '  scale.sh diff <namespace> <kind>'
  echo
  echo '    dump    create current <replicas> status  (dump filename := .<cluster>/<namespace>_<kind>.txt)'
  echo '    load    set <replicas> from dump file (kubectl scale <kind> --replicas <replicas> -n <namespace>)'
  echo '    set     set <replicas> from arg       (kubectl scale <kind> --replicas <replicas> -n <namespace>)'
  echo '    diff    diff replicas between cluster adn dump file'
}
assert () {
  if [ $# -eq 0 ]; then
    usage && exit 1
  fi

  until [ -z "$1" ]; do
    if [ -z "$1" ]; then
      usage && exit 1
    else
      shift
    fi
  done
}

# variables
CLUSTER=$(kubectl config current-context)

command=$1
namespace=$2
kind=$3
replicas=$4
dump_dir=".$CLUSTER"
dump_file="$dump_dir/${namespace}_${kind}.txt"

mkdir -p $dump_dir

# argument validation
assert $kind $namespace

# Main
case $command in
  dump)
    echo $(date) > $dump_file
    kubectl get $kind -n $namespace >> $dump_file
    echo "==================== $dump_file ===================="
    cat $dump_file
    ;;

  load)
    tail -n +3 $dump_file | while read line;
    do
      name=$(echo $line | cut -f1 -d' ')
      replicas=$(echo $line | cut -f2 -d' ')
      kubectl scale $kind -n $namespace --replicas $replicas $name
    done
    ;;

  set)
    assert $replicas
    names=$(kubectl get $kind -n $namespace | tail -n +2 | cut -f1 -d' ')

    if [ -z "$names" ]; then
      exit 0
    fi

    echo "$names" | while read name;
    do
      kubectl scale $kind -n $namespace --replicas $replicas $name
    done
    ;;

  diff)
    echo $dump_file
    kubectl get $kind -n $namespace
    ;;

  *)
    # pring usage
    usage
    ;;
esac
