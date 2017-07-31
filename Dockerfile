FROM centos

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ADD run.sh /
ADD gpg_sign.expect /

ENV \
  GO_VERSION=1.8.3 \
  PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  GOPATH=/go \
  GIT_BRANCH=release-1.5 \
  OUTPUT_DIR=/output \
  GIT_NAME="James Eckersall" \
  GIT_EMAIL=james.eckersall@gmail.com \
  GPG_KEY_NAME="" \
  GPG_KEY_FILE="" \
  GPG_KEY_PASSPHRASE=""

RUN \
  yum -y install epel-release && \
  yum -y --enablerepo=epel-testing install createrepo expect git make rpm-sign rpmbuild rsync tito which && \
  mkdir /go /output && \
  chmod 0775 /run.sh /go /output

ADD https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz /tmp/

RUN \
  tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
  rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz

VOLUME $OUTPUT_DIR
ENTRYPOINT ["/run.sh"]
