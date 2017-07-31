# docker-openshift-build

This will build Openshift Origin RPM's.
Set the environment variable GIT_BRANCH to the branch you require
Mount a volume to OUTPUT_DIR and the RPM's will be saved here and a repo created

This image will also sign the RPM's with a GPG key.
To use this, provide the following variables:
GPG_KEY_NAME
GPG_KEY_FILE
GPG_KEY_PASSPHRASE or GPG_KEY_PASSPHRASE_FILE

Example (without gpg signing):

docker run -v /home/user/openshift-rpm:/output jameseckersall/openshift-build

Example (with gpg signing):

docker run \
  -v /home/user/openshift-rpm:/output
  -e GPG_KEY_NAME=bob@bob.com \
  -e GPG_KEY_PASSPHRASE='bobs secret passphrase' \
  jameseckersall/openshift-build
