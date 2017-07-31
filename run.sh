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

if [ -f "${GPG_KEY_FILE}" ]; then
  gpg-agent --daemon
  echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf
  gpg-connect-agent reloadagent /bye
  gpg --import ${GPG_KEY_FILE}

  find $OUTPUT_DIR/ -iname '*.rpm' -print0 | xargs -0 expect /gpg_sign.expect "${GPG_KEY_PASSPHRASE}"
fi
