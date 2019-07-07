FROM ubuntu:18.04
LABEL maintainer="badfeanor@yandex.ru"
ARG VERSION=2.0.0

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils \
    && apt-get -y install \
        maven \
        wget \
        curl \
        python \
        openjdk-8-jdk-headless

RUN cd /tmp \
    && wget --no-check-certificate https://dist.apache.org/repos/dist/release/atlas/${VERSION}/apache-atlas-${VERSION}-sources.tar.gz \
    && mkdir /tmp/atlas-src \
    && tar --strip 1 -xzvf apache-atlas-${VERSION}-sources.tar.gz -C /tmp/atlas-src \
    && rm apache-atlas-${VERSION}-sources.tar.gz \
    && cd /tmp/atlas-src \
    && export MAVEN_OPTS="-Xms2g -Xmx2g" \
    && export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    && mvn clean -DskipTests package -Pdist \
    && tar -xzvf /tmp/atlas-src/distro/target/apache-atlas-${VERSION}-server.tar.gz -C /opt \
    && rm -Rf /tmp/atlas-src

COPY atlas-application.properties /opt/apache-atlas-${VERSION}/conf
COPY entrypoint.sh /opt/apache-atlas-${VERSION}/bin
COPY atlas-env.sh /opt/apache-atlas-${VERSION}/conf
COPY atlas_start.py.patch atlas_config.py.patch /opt/apache-atlas-${VERSION}/bin/

RUN cd /opt/apache-atlas-${VERSION}/bin \
    && ./atlas_start.py -setup || true
CMD ["/bin/bash", "/opt/apache-atlas-2.0.0/bin/entrypoint.sh"]
#VOLUME ["/opt/apache-atlas-2.0.0/conf", "/opt/apache-atlas-2.0.0/logs"]
