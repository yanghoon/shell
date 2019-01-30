#!/bin/bash
if [ "$(which openssl)" == "" ]; then
  {
    . /etc/os-release
    test "$ID" == "alpine" && apk add openssl
  }
fi

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > .helm.sh
bash .helm.sh -v v2.9.1
