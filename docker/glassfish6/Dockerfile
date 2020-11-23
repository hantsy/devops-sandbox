# Modified from https://github.com/AdamBien/docklands/blob/master/glassfish/Dockerfile
FROM openjdk:8-jdk
LABEL maintainer="Hantsy Bai, hantsy@gmail.com" description="Eclipse Glassfish v6"

ENV ADMIN_USER="admin"
ENV ADMIN_PASSWORD=""

ENV GLASSFISH_ARCHIVE="glassfish6"
ENV GLASSFISH_VERSION="6.0.0-RC2"
ENV DOMAIN_NAME="domain1"
ENV INSTALL_DIR="/opt/appsvr"
ENV GLASSFISH_ZIP_URL="https://download.eclipse.org/ee4j/glassfish/glassfish-${GLASSFISH_VERSION}.zip"

RUN useradd -b /opt -m -s /bin/sh -d ${INSTALL_DIR} serveradmin && echo serveradmin:serveradmin | chpasswd
RUN curl -o "${GLASSFISH_ARCHIVE}.zip" -L "${GLASSFISH_ZIP_URL}" \
    && unzip "${GLASSFISH_ARCHIVE}.zip" -d "${INSTALL_DIR}" \
    && chown -R serveradmin:serveradmin "${INSTALL_DIR}" \
    && chmod -R a+rw "${INSTALL_DIR}" \
    && rm "${GLASSFISH_ARCHIVE}.zip" \
    && true
	
ENV GLASSFISH_HOME="${INSTALL_DIR}/${GLASSFISH_ARCHIVE}/glassfish"
ENV DEPLOYMENT_DIR="${GLASSFISH_HOME}/domains/domain1/autodeploy"

COPY ./entrypoint.sh "${INSTALL_DIR}"

USER serveradmin
WORKDIR ${INSTALL_DIR}
ENTRYPOINT ["sh", "-c", "./entrypoint.sh"]

EXPOSE 4848 8009 8080 8181