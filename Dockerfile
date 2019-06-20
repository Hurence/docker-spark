# docker build --rm -t hurence/spark  .
# docker tag hurence/spark:latest hurence/spark:2.4.3
FROM anapsix/alpine-java:8_jdk_nashorn

ARG spark_version=2.4.3
ARG scala_version=2.11

MAINTAINER hurence

RUN apk add --update unzip wget curl docker jq coreutils procps vim

VOLUME ["/spark"]

# Spark
RUN curl -s ftp://ftp.crihan.fr/mirrors/www.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz | tar -xz -C /opt/
RUN cd /opt && ln -s spark-${spark_version}-bin-hadoop2.7 spark
ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin
WORKDIR $SPARK_HOME/

RUN mkdir /opt/jmx; cd /opt/jmx; wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.9/jmx_prometheus_javaagent-0.9.jar
ADD jmx_prometheus.yml /opt/jmx/jmx_prometheus.yml

ADD metrics.properties /opt/spark/conf/metrics.properties
