
ENV POSTGRES_PORT_5432_TCP_PORT=5432

ENV POSTGRES_PASSWORD=keycloak

ENV POSTGRES_USER=keycloak

ENV POSTGRES_PORT_5432_TCP_ADDR=postgres

ENV POSTGRES_DATABASE=keycloak

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV JAVA_HOME=/usr/lib/jvm/java

ENV KEYCLOAK_VERSION=3.3.0.CR2

ENV LAUNCH_JBOSS_IN_BACKGROUND=1

ENV PROXY_ADDRESS_FORWARDING=false

ENV JDBC_POSTGRES_VERSION=42.1.4

ENV JDBC_MYSQL_VERSION=5.1.18

ENV JBOSS_HOME=/opt/jboss/keycloak

EXPOSE 8080/tcp

VOLUME /opt/jboss/keycloak/realms

VOLUME /opt/jboss/keycloak/standalone/data

VOLUME /opt/jboss/keycloak/standalone/log

VOLUME /opt/jboss/keycloak/themes/che
USER 1000
WORKDIR /opt/jboss
ENTRYPOINT ["start-keycloak.sh","-Dkeycloak.migration.action=import","-Dkeycloak.migration.provider=dir","-Dkeycloak.migration.strategy=IGNORE_EXISTING","-Dkeycloak.migration.dir=/opt/jboss/keycloak/realms/","-Djboss.bind.address=0.0.0.0"]


