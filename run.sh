#!/bin/bash

GIT_BRANCH=release-1.5
RPM_VERSION=1.5.1
RPM_RELEASE=1

git config --global user.name "James Eckersall"
git config --global user.email "james.eckersall@gmail.com"

echo "Cloning github.com/openshift/origin ..."
go get -v github.com/openshift/origin
cd /go/src/github.com/openshift/origin
git checkout $GIT_BRANCH
yum-builddep -y origin.spec

tito tag --use-version=${RPM_VERSION} --use-release=${RPM_RELEASE} --no-auto-changelog
tito build --test --rpm --dist=el7
