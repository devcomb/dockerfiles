FROM eclipse/ubuntu_jdk8
USER root

#ca.crt is not stored in repo for security.
#If using this as template add your ca.cert
#to Dockerfile folder before building image
COPY ca.crt /root/ca.crt
RUN keytool -import -noprompt -file /root/ca.crt \
    -storepass changeit -keystore /etc/ssl/certs/java/cacerts -alias ocpcert && \
    rm /root/ca.crt

USER user
WORKDIR /projects
ENTRYPOINT ["/home/user/entrypoint.sh"]
CMD tail -f /dev/null
