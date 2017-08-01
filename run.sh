#!/bin/bash

set -o pipefail

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

  cat <<EOF > ~/.rpmmacros
%_signature gpg
%_gpg_path /root/.gnupg
%_gpg_name ${GPG_KEY_NAME}
%_gpgbin /usr/bin/gpg
EOF
  gpg-agent --daemon
  echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf
  gpg-connect-agent reloadagent /bye
  gpg --import ${GPG_KEY_FILE}
  gpg --export --armor ${GPG_KEY_NAME} > ${OUTPUT_DIR}/RPM-GPG-KEY-${GPG_KEY_NAME}

  if [ "${GPG_KEY_PASSPHRASE}" != "" ]; then
    export GPG_PASS=${GPG_KEY_PASSPHRASE}
  else
    export GPG_PASS=$(cat ${GPG_KEY_PASSPHRASE_FILE})
  fi

  #find $OUTPUT_DIR/ -iname '*.rpm' -print0 | xargs -0 -n 1 expect -f /gpg_sign.expect "${GPG_PASS}"
  find $OUTPUT_DIR/ -iname '*.rpm' -print0 | xargs -0 expect -f /gpg_sign.expect
fi

createrepo $OUTPUT_DIR
echo "Success"
