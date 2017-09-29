FROM alpine:3.6

WORKDIR /wrk
ENV ENV=/etc/.shinit
ADD shinit.sh /etc/.shinit

RUN apk add --update \
    git git-svn git-perl openssh subversion

VOLUME /wrk