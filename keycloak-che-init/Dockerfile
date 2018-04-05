FROM jboss/keycloak-openshift:3.3.0.CR2-3
ARG CACHEBUST=1
RUN echo $CACHEBUST
COPY standalone.xml  /opt/jboss/keycloak/standalone/configuration/standalone.xml
USER 1000
WORKDIR /opt/jboss
RUN cd /opt/jboss/keycloak && \
    curl -L https://downloads.jboss.org/keycloak/3.3.0.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.3.0.Final.tar.gz | tar zx
#-Djboss.bind.address=0.0.0.0 -Djboss.modules.system.pkgs=com.sun.java.swing -Dcom.ibm.jsse2.overrideDefaultTLS=true -Dlogging.configuration=file:/opt/jboss/keycloak/bin/jboss-cli-logging.properties
#RUN sed -i -e 's/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"\/>/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true" proxy-address-forwarding="true"\/>/' /opt/jboss/keycloak/standalone/configuration/standalone.xml
ENTRYPOINT [ "openshift-entrypoint.sh" ]
CMD ["start-keycloak.sh", "--debug","-Dkeycloak.migration.action=import","-Dkeycloak.migration.provider=dir","-Dkeycloak.migration.strategy=IGNORE_EXISTING","-Dkeycloak.migration.dir=/opt/jboss/wildfly/realms/","-Djboss.bind.address=0.0.0.0","-Djboss.modules.system.pkgs=com.sun.java.swing","-Dcom.ibm.jsse2.overrideDefaultTLS=true","-Dlogging.configuration=file:/opt/jboss/keycloak/bin/jboss-cli-logging.properties"]
