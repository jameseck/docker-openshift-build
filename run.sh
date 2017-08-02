#!/bin/bash

set -eo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"

echo -e "${GREEN}Cloning github.com/openshift/origin ...${NC}"
go get -v github.com/openshift/origin
cd /go/src/github.com/openshift/origin
git checkout "${GIT_BRANCH}"
yum-builddep -y origin.spec
echo -e "${GREEN}Building RPM's${NC}"
make build-rpms

# At this point the rpm's are in /go/src/github.com/openshift/origin/_output/local/releases/
# We should check that we can sign them and createrepo before syncing to $OUTPUT_DIR/

RPM_DIR=/go/src/github.com/openshift/origin/_output/local/releases/

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
  gpg --import "${GPG_KEY_FILE}"
  gpg --export --armor "${GPG_KEY_NAME}" > "${OUTPUT_DIR}/RPM-GPG-KEY-${GPG_KEY_NAME}"

  if [ "${GPG_KEY_PASSPHRASE}" != "" ]; then
    export GPG_PASS="${GPG_KEY_PASSPHRASE}"
  else
    export GPG_PASS=$(cat "${GPG_KEY_PASSPHRASE_FILE}")
  fi

  find "${RPM_DIR}/" -iname '*.rpm' -print0 | xargs -0 -n 1 /gpg_sign.expect
fi

createrepo "${RPM_DIR}"
rsync -avh "${RPM_DIR}/" "${OUTPUT_DIR}/"
echo -e "${GREEN}Success${NC}"
