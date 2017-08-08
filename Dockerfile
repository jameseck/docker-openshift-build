FROM centos

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ENV \
  PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  GO_VERSION=1.7.6 \
  GOPATH=/go \
  GIT_BRANCH=release-1.5 \
  OUTPUT_DIR=/output \
  GIT_NAME="James Eckersall" \
  GIT_EMAIL=james.eckersall@gmail.com \
  GPG_KEY_NAME="" \
  GPG_KEY_FILE="" \
  GPG_KEY_PASSPHRASE="" \
  GPG_KEY_PASSPHRASE_FILE="" \
  BUILD_NUMBER=""

RUN \
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
  yum -y install epel-release && \
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
  yum -y --enablerepo=epel-testing install bsdtar cpp createrepo expect gcc git glibc glibc-common glibc-devel glibc-headers golang golang-bin golang-src kernel-headers keyutils-libs-devel krb5-devel libarchive libcom_err-devel libgomp libmpc libselinux-devel libsepol-devel libverto-devel make mpfr pcre-devel rpm-sign rpmbuild rpmrebuild rsync tito which && \
  mkdir -m 0775 /go /output

RUN \
  curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz

ADD run.sh /
ADD gpg_sign.expect /

RUN \
  chmod 0755 /run.sh /gpg_sign.expect

VOLUME $OUTPUT_DIR
ENTRYPOINT ["/run.sh"]
