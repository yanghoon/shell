#/bin/bash

# function
Usage () {
  echo ' Backup and restore replicas'
  echo 
  echo 'Usgae: '
  echo '  scale.sh dump <kind> <namespace>'
  echo '  scale.sh load <kind> <namespace>'
  echo '  scale.sh set  <kind> <namespace> <replicas>'
  echo '  scale.sh diff <kind> <namespace>'
  echo
  echo '    dump    create current <replicas> status  (dump filename := <cluster>+<namespace>+<kind>.txt)'
  echo '    load    set <replicas> from dump file (kubectl scale <kind> --replicas <replicas> -n <namespace>)'
  echo '    set     set <replicas> from arg       (kubectl scale <kind> --replicas <replicas> -n <namespace>)'
  echo '    diff    diff replicas between cluster adn dump file'
}

set -e

CLUSTER=$(kubectl config current-context)

command=$1
kind=$2
namespace=$3
replicas=$4

dump_file="$cluster+$namespace+$kind.txt"

case $command in
  dump)
    echo $dump_file
    kubectl get $kind -n $namespace
    ;;

  load)
    cat $dump_file
    ;;

  set)
    echo "kubectl scale $kind --replicas $replicas -n $namespace"
    ;;

  diff)
    echo $dump_file
    kubectl get $kind -n $namespace
    ;;

  *)
    # pring usage
    Usage
    ;;
esac
