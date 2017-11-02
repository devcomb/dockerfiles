FROM jboss/wildfly:11.0.0.Final

USER jboss

WORKDIR /opt/jboss/wildfly

RUN rm -rf /opt/jboss/wildfly/*
RUN curl -L https://downloads.jboss.org/keycloak/3.3.0.Final/keycloak-3.3.0.Final.tar.gz | tar zx
RUN mv /opt/jboss/wildfly/keycloak-3.3.0.Final/* .
RUN curl -L https://downloads.jboss.org/keycloak/3.3.0.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.3.0.Final.tar.gz | tar zx
RUN sed -i -e 's/<extensions>/&\n        <extension module="org.keycloak.keycloak-adapter-subsystem"\/>/' standalone/configuration/standalone.xml && \
    sed -i -e 's/<profile>/&\n        <subsystem xmlns="urn:jboss:domain:keycloak:1.1"\/>/' standalone/configuration/standalone.xml && \
    sed -i -e 's/<subsystem xmlns="urn:jboss:domain:security:2.0">\n            <security-domains>/&\n                <security-domain name="keycloak">\n                    <authentication>\n                        <login-module code="org.keycloak.adapters.jboss.KeycloakLoginModule" flag="required"\/>\n                    <\/authentication>\n                <\/security-domain>/' standalone/configuration/standalone.xml

ADD docker-entrypoint.sh /opt/jboss/
ADD setLogLevel.xsl /opt/jboss/wildfly/

USER root

RUN chgrp -R 0 /opt/jboss/wildfly && \
    chmod -R g=u /opt/jboss/wildfly

USER jboss

WORKDIR /opt/jboss


# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
