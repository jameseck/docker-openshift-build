FROM centos

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ADD https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz /tmp/
ADD run.sh /

ENV GO_VERSION=1.8.3

RUN \
  yum -y install epel-release && \
  yum -y --enablerepo=epel-testing install createrepo git make rpmbuild tito which && \
  tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
  rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
  mkdir /go /output && \
  chmod 0775 /go /output

ENV PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=/go

VOLUME /output
