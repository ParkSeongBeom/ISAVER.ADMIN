#!/bin/sh

export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=8829"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=8820"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=8821"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=8822"

export CATALINA_BASE=/isaver/was/isaver_ws
export CATALINA_HOME=/isaver/was/tomcat7
export CATALINA_OPTS="$CATALINA_OPTS -Denv=product -Denv.servername=isaver_ws"

${CATALINA_HOME}/bin/shutdown.sh
