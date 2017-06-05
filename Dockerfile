FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp
ADD target/website-home-page-0.0.1-SNAPSHOT.jar app.jar
RUN sh -c 'touch /app.jar'
ENV JAVA_OPTS=""
