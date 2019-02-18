#!/bin/sh

export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=8809"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=8820"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=8801"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=8802"

export CATALINA_BASE=/isaver/was/isaver_hybrid
export CATALINA_HOME=/isaver/was/tomcat7
export CATALINA_OPTS="$CATALINA_OPTS -Denv=product -Denv.servername=isaver_hybrid"

${CATALINA_HOME}/bin/shutdown.sh
