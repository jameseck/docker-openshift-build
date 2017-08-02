docker run \
  -it \
  -v `pwd`/gpgkey:/gpgkey \
  -v `pwd`/output:/output \
  -e GPG_KEY_NAME=test@test.com \
  -e GPG_KEY_FILE=/gpgkey/gpg.key \
  -e GPG_KEY_PASSPHRASE_FILE=/gpgkey/gpg.pass \
  jameseckersall/openshift-build:${VERSION}
