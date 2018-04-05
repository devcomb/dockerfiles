#!/bin/bash

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    wildfly/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi
if [ $KEYCLOAK_HTTPS  == "true" ]; then
  if [ ! $KEYCLOAK_HTTPS_PASSWORD ]; then
    export KEYCLOAK_HTTPS_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
  fi
  if [ ! -f /opt/jboss/wildfly/standalone/configuration/keycloak.jks ]; then
    export KEYCLOAK_KEYSTORE_JKS="/opt/jboss/wildfly/standalone/configuration/keycloak.jks"
    cd /opt/jboss/wildfly/
    csplit -z -f crt- $KEYCLOAK_CRTFILE '/-----BEGIN CERTIFICATE-----/' '{*}'
    for file in crt-*
      do keytool -import -noprompt -keystore $KEYCLOAK_KEYSTORE_JKS -file $file -storepass $KEYCLOAK_PASSWORD -alias service-$file
    done
  fi

  #openssl pkcs12 -export -inkey $KEYCLOAK_KEYFILE -in $KEYCLOAK_CRTFILE -out $KEYCLOAK_KEYSTORE_PKCS12 -password pass:$KEYCLOAK_HTTPS_PASSWORD
  #keytool -importkeystore -noprompt -srckeystore $KEYCLOAK_KEYSTORE_PKCS12 -srcstoretype pkcs12 -destkeystore $KEYCLOAK_KEYSTORE_JKS -storepass $KEYCLOAK_HTTPS_PASSWORD -srcstorepass $KEYCLOAK_HTTPS_PASSWORD

  #keytool -genkey -alias selfsigned -keysize 2048 -keyalg RSA \
  #  -dname "CN=name,OU=ou,O=o,c=pt" \
  #  -validity 10950 \
  #  -keystore /opt/jboss/wildfly/standalone/configuration/keycloak.jks \
  #  -storepass $KEYCLOAK_HTTPS_PASSWORD -storetype pkcs12 -noprompt
#   sed -i -e '0,/<security-realms>/{s/<security-realms>/&\n            <security-realm name="UndertowRealm">\n                <server-identities>\n                    <ssl>\n                    <keystore path="keycloak.jks" relative-to="jboss.server.config.dir" keystore-password="\${env.KEYCLOAK_HTTPS_PASSWORD}" \/>\n                    <\/ssl>\n                <\/server-identities>\n            <\/security-realm>/}' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#   sed -i -e 's/<http-authentication-factory name="management-http-authentication" http-server-mechanism-factory="global" security-domain="ManagementDomain">/<http-authentication-factory name="management-http-authentication" http-server-mechanism-factory="global" security-domain="ManagementDomain">/' /opt/jboss/wildfly/standalone/configuration/standalone.xml

#    sed -i -e 's/<https-listener name="https" socket-binding="https" security-realm="ApplicationRealm" enable-http2="true"\/>/<https-listener name="https" socket-binding="https" security-realm="ApplicationRealm" enable-http2="true" proxy-address-forwarding="true"\/>/' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#    sed -i -e 's/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"\/>/<http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true" proxy-address-forwarding="true"\/>/' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#    sed -i -e '0,/<server name="default-server">/{s/<server name="default-server">/&\n        <ajp-listener name="ajp-default" socket-binding="ajp" redirect-socket="https" scheme="https"\/>/}' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#    sed -i -e '0,/<filter-ref name="x-powered-by-header"/>/{s/<filter-ref name="x-powered-by-header"/>/&\n            <filter-ref name="proxy-peer"/>/}' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#    sed -i -e '0,/<response-header name="x-powered-by-header" header-name="X-Powered-By" header-value="Undertow\/1"\/>/{s/<response-header name="x-powered-by-header" header-name="X-Powered-By" header-value="Undertow\/1"\/>/&\n            <filter name="proxy-peer" module="io.undertow.core" class-name="io.undertow.server.handlers.ProxyPeerAddressHandler"\/>/}' /opt/jboss/wildfly/standalone/configuration/standalone.xml
#    sed -i -e '0,/<security-realm name="ManagementRealm">/{s/<security-realm name="ManagementRealm">/&\n<server-identities>\n        <ssl>\n            <keystore path="application.keystore" relative-to="jboss.server.config.dir" keystore-password="password" alias="server" key-password="password" generate-self-signed-certificate-host="localhost"\/>\n        <\/ssl>\n    <\/server-identities>/}' /opt/jboss/wildfly/standalone/configuration/standalone.xml
    sed -i -e 's/keystore-password="password"/keystore-password="'$KEYCLOAK_HTTPS_PASSWORD'"/' /opt/jboss/wildfly/standalone/configuration/standalone.xml
    sed -i -e 's/key-password="password"/key-password="'$KEYCLOAK_HTTPS_PASSWORD'"/' /opt/jboss/wildfly/standalone/configuration/standalone.xml
fi
if [ $KEYCLOAK_CHE == "true" ]; then
  export KEYCLOAK_CLI_ARGS="$KEYCLOAK_CLI_ARGS -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=dir -Dkeycloak.migration.strategy=IGNORE_EXISTING -Dkeycloak.migration.dir=/opt/jboss/wildfly/realms/"
fi


exec /opt/jboss/wildfly/bin/standalone.sh $KEYCLOAK_CLI_ARGS
exit $?
