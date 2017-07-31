#!/bin/bash

git config --global user.name "James Eckersall"
git config --global user.email "james.eckersall@gmail.com"

echo "Cloning github.com/openshift/origin ..."
go get -v github.com/openshift/origin
cd /go/src/github.com/openshift/origin
git checkout $GIT_BRANCH
yum-builddep -y origin.spec
make build-rpms
rsync -avh /go/src/github.com/openshift/origin/_output/local/releases/ /output/
