#!/bin/sh
export UPAGENT_HOME=/isaver/was/isaver_external/ISAVER.EXTERNAL.AGENT
echo "isaver External Agent shutting down....."

if [ -z "'ps -eaf | grep java|grep $UPAGENT_HOME'" ]; then
	echo "iSaver External Agent was not started."
else
	echo "iSaver External Agent was started."
	ps -eaf | grep java | grep $UPAGENT_HOME | awk '{print $2}' |
		while read PID
			do
			echo "Killing $PID ..."
			kill -9 $PID
			echo
			echo "iSaver External Agent is being shutdowned... "
			done
fi