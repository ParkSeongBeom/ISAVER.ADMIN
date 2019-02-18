#!/bin/sh

export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=8819"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=8810"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=8811"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=8812"

export CATALINA_BASE=/isaver/was/isaver_api
export CATALINA_HOME=/isaver/was/tomcat7
export CATALINA_OPTS="$CATALINA_OPTS -Denv=product -Denv.servername=isaver_api"

${CATALINA_HOME}/bin/shutdown.sh
