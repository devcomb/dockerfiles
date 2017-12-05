FROM jboss/wildfly:11.0.0.Final

USER jboss

WORKDIR /opt/jboss/wildfly

RUN rm -rf /opt/jboss/wildfly/*
RUN curl -L https://downloads.jboss.org/keycloak/3.3.0.Final/keycloak-3.3.0.Final.tar.gz | tar zx
RUN mv /opt/jboss/wildfly/keycloak-3.3.0.Final/* .
RUN curl -L https://downloads.jboss.org/keycloak/3.3.0.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.3.0.Final.tar.gz | tar zx

USER root

RUN chgrp -R 0 /opt/jboss/wildfly && \
    chmod -R g=u /opt/jboss/wildfly

USER jboss

ARG CACHEBUST=1
RUN echo $CACHEBUST
ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml
ADD docker-entrypoint.sh /opt/jboss/
ADD setLogLevel.xsl /opt/jboss/wildfly/
ADD themes /opt/jboss/wildfly/themes/keycloak/
ADD realms /opt/jboss/wildfly/realms/

WORKDIR /opt/jboss
ENV KEYCLOAK_CLI_ARGS="-Djboss.bind.address=0.0.0.0 -Djboss.modules.system.pkgs=com.sun.java.swing -Dcom.ibm.jsse2.overrideDefaultTLS=true -Dlogging.configuration=file:/opt/jboss/keycloak/bin/jboss-cli-logging.properties "
ENV KEYCLOAK_HTTPS="false"
ENV KEYCLOAK_CHE="false"
ENV PROXY_ADDRESS_FORWARDING="true"
RUN sed -i -e 's/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"\/>/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true" proxy-address-forwarding="true"\/>/' /opt/jboss/wildfly/standalone/configuration/standalone.xml



# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]
