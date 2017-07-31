#!/bin/bash

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"

echo "Cloning github.com/openshift/origin ..."
go get -v github.com/openshift/origin
cd /go/src/github.com/openshift/origin
git checkout $GIT_BRANCH
yum-builddep -y origin.spec
make build-rpms
rsync -avh /go/src/github.com/openshift/origin/_output/local/releases/ $OUTPUT_DIR/
