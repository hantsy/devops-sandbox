#!/bin/bash

PATH=$PATH:${GLASSFISH_HOME}/bin/

echo "ADMIN_USER: ${ADMIN_USER}"
echo "ADMIN_PASSWORD: ${ADMIN_PASSWORD}"
echo "DOMAIN_NAME: ${DOMAIN_NAME}"

if [ -z "${ADMIN_PASSWORD}" ]; then
	asadmin start-domain "${DOMAIN_NAME}"
else
	NEW_PASSWORDFILE="/tmp/new_passwordfile "
	PASSWORDFILE="/tmp/passwordfile"
	echo "set AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}"
	echo "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" >"${NEW_PASSWORDFILE}"
	echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" >"${PASSWORDFILE}"

	asadmin --user "${ADMIN_USER}" start-domain "${DOMAIN_NAME}"
	asadmin --user "${ADMIN_USER}" --passwordfile "${NEW_PASSWORDFILE}" change-admin-password --domain_name "${DOMAIN_NAME}"
	asadmin --user "${ADMIN_USER}" --passwordfile "${PASSWORDFILE}" enable-secure-admin
	asadmin --user "${ADMIN_USER}" --passwordfile "${PASSWORDFILE}" restart-domain "${DOMAIN_NAME}"
fi
