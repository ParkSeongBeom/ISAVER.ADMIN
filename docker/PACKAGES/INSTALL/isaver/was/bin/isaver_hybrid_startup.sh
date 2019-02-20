#!/bin/sh

export JAVA_OPTS="-server"
export JAVA_OPTS="$JAVA_OPTS -Xms512m"
export JAVA_OPTS="$JAVA_OPTS -Xmx1024m"
export JAVA_OPTS="$JAVA_OPTS -XX:NewSize=256m"
export JAVA_OPTS="$JAVA_OPTS -XX:MaxNewSize=256m"
export JAVA_OPTS="$JAVA_OPTS -XX:PermSize=256m"
export JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=512m"

export JAVA_OPTS="$JAVA_OPTS -XX:+UseParNewGC"
export JAVA_OPTS="$JAVA_OPTS -XX:ParallelGCThreads=8"
export JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC"

export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=8849"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=8840"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=8841"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=8842"

export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=10994"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"

export CATALINA_BASE=/isaver/was/isaver_hybrid
export CATALINA_HOME=/isaver/was/tomcat7
export CATALINA_OPTS="$CATALINA_OPTS -Denv=product -Denv.servername=isaver_hybrid"

${CATALINA_HOME}/bin/startup.sh
