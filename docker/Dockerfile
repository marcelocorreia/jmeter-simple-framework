FROM openjdk:8-jdk-alpine

RUN apk update

ARG jmeter_version="3.3"

RUN set -ex
RUN apk add --no-cache \
        py-pip \
        build-base \
        python-dev \
        libffi-dev \
        openssl-dev \
        bash \
        curl \
        tzdata \
        git \
        make \
        openssh \
        jq \
        unzip

RUN mkdir /opt/tests /opt/log
RUN curl https://s3-ap-southeast-2.amazonaws.com/correia-artifacts/packages/custom-jmeter-${jmeter_version}.tar.gz -o /opt/apache-jmeter-${jmeter_version}.tgz
WORKDIR /opt

RUN tar -xvzf apache-jmeter-${jmeter_version}.tgz
RUN ln -s apache-jmeter-${jmeter_version} jmeter
RUN rm apache-jmeter-${jmeter_version}.tgz
RUN rm /var/cache/apk/*
ENV JMETER_HOME /opt/jmeter

