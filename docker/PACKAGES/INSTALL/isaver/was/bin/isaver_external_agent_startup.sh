#!/bin/bash
nohup java -server -Xms256m -Xmx512m -XX:NewRatio=12 -XX:PermSize=256m -XX:MaxPermSize=256m -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/isaver/was/isaver_external/heapdump -Dfile.encoding=UTF-8 -jar /isaver/was/isaver_external/ISAVER.EXTERNAL.AGENT.jar /isaver/was/isaver_external/deploy.properties 1> /dev/null 2>&1&