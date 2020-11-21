# Modified from https://github.com/AdamBien/docklands/blob/master/glassfish/Dockerfile
FROM openjdk:8-jdk
LABEL maintainer="Hantsy Bai, hantsy@gmail.com" description="Eclipse Glassfish v6"

ENV ADMIN_USER admin
ENV ADMIN_PASSWORD adminadmin

ENV GLASSFISH_ARCHIVE glassfish6
ENV GLASSFISH_VERSION 6.0.0-RC2
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt

RUN useradd -b /opt -m -s /bin/sh -d ${INSTALL_DIR} serveradmin && echo serveradmin:serveradmin | chpasswd
RUN curl -o ${GLASSFISH_ARCHIVE}.zip -L https://download.eclipse.org/ee4j/glassfish/glassfish-${GLASSFISH_VERSION}.zip \
    && unzip ${GLASSFISH_ARCHIVE}.zip -d ${INSTALL_DIR} \
    && chown -R serveradmin:serveradmin /opt \
    && chmod -R a+rw /opt \
    && rm ${GLASSFISH_ARCHIVE}.zip \
    && true
	
ENV GLASSFISH_HOME ${INSTALL_DIR}/${GLASSFISH_ARCHIVE}/glassfish
ENV DEPLOYMENT_DIR ${GLASSFISH_HOME}/domains/domain1/autodeploy

USER serveradmin
WORKDIR ${INSTALL_DIR}

ENTRYPOINT export PATH=$PATH:${INSTALL_DIR}/${GLASSFISH_ARCHIVE}/bin/ \
    && echo "set AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" \
    && echo "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" > /tmp/new_passwordfile \
    && echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" > /tmp/passwordfile \
	&& asadmin --user ${ADMIN_USER} --passwordfile /tmp/new_passwordfile change-admin-password --domain_name ${DOMAIN_NAME}\
	&& asadmin --user ${ADMIN_USER} --passwordfile /tmp/passwordfile start-domain ${DOMAIN_NAME} \
	&& asadmin --user ${ADMIN_USER} --passwordfile /tmp/passwordfile enable-secure-admin \
	&& asadmin --user ${ADMIN_USER} --passwordfile /tmp/passwordfile restart-domain ${DOMAIN_NAME} \
	&& true

EXPOSE 4848 8009 8080 8181