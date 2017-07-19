FROM anapsix/alpine-java

ARG spark_version=2.1.1
ARG scala_version=2.11

MAINTAINER hurence

RUN apk add --update unzip wget curl docker jq coreutils procps vim


VOLUME ["/spark"]


# Spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${spark_version}-bin-hadoop2.7.tgz | tar -xz -C /opt/
RUN cd /opt && ln -s spark-${spark_version}-bin-hadoop2.7 spark
ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin
WORKDIR $SPARK_HOME/

RUN mkdir /opt/jmx; cd /opt/jmx; wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.9/jmx_prometheus_javaagent-0.9.jar
ADD jmx_prometheus.yml /opt/jmx/jmx_prometheus.yml
RUN mkdir /opt/jmx/spark; cd /opt/jmx/spark
ADD metrics.properties /opt/jmx/spark/metrics.properties