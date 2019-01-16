
# Usage
```
$ bash ns-grep.sh -h
Filter namespaces list with grep options. and could execute any command with each namespace name

Usage:
  ns-grep.sh [grep options]
  ns-grep.sh [grep options] -- <command>

  [grep options]  by passed as grep options
  <command>       be executed by xargs with namespace name({})
                  eg) ./ns-grep.sh default -- kubectl get pod -n {}

$ bash ns-scale.sh
 Backup and restore replicas

Usgae:
  scale.sh dump <namespace> <kind>
  scale.sh load <namespace> <kind>
  scale.sh set  <namespace> <kind> <replicas>
  scale.sh diff <namespace> <kind>

    dump    create current <replicas> status  (dump filename := .<cluster>/<namespace>_<kind>.txt)
    load    set <replicas> from dump file (kubectl scale <kind> --replicas <replicas> -n <namespace>)
    set     set <replicas> from arg       (kubectl scale <kind> --replicas <replicas> -n <namespace>)
    diff    diff replicas between cluster adn dump file
```

# Examples
## ns-grep.sh
```
$ cat ns.txt
default
my-namespace
$ bash ns-grep.sh -f ns.txt -- kubectl get pod -n {}
```

## ns-scale.sh
```
$ bash ns-scale.sh dump default deploy
==================== .minikube/default_deploy.txt ====================
1999 01 16 Wed PM 7:23:04
NAME                                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
awesome-media-backend-deployment    1         1         1            1           43d
awesome-media-frontend-deployment   1         1         1            1           43d
cloud-store-java8                   1         1         1            1           8d

$ bash ns-scale.sh set default deploy 0
deployment.extensions/awesome-media-backend-deployment scaled
deployment.extensions/awesome-media-frontend-deployment scaled
deployment.extensions/cloud-store-java8 scaled

$ kubectl get deploy -n default
NAME                                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
awesome-media-backend-deployment    0         0         0            0           43d
awesome-media-frontend-deployment   0         0         0            0           43d
cloud-store-java8                   0         0         0            0           8d

$ bash ns-scale.sh load default deploy
deployment.extensions/awesome-media-backend-deployment scaled
deployment.extensions/awesome-media-frontend-deployment scaled
deployment.extensions/cloud-store-java8 scaled

$ kubectl get deploy -n default
NAME                                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
awesome-media-backend-deployment    1         1         1            1           43d
awesome-media-frontend-deployment   1         1         1            1           43d
cloud-store-java8                   1         1         1            1           8d
```
