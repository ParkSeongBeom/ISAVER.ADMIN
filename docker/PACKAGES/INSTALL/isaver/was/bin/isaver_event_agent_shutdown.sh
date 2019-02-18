#!/bin/sh
export UPAGENT_HOME=/isaver/was/isaver_event/ISAVER.EVENT.AGENT
echo "iSaver Event Agent shutting down....."

if [ -z "'ps -eaf | grep java|grep $UPAGENT_HOME'" ]; then
	echo "iSaver Event Agent was not started."
else
	echo "iSaver Event Agent was started."
	ps -eaf | grep java | grep $UPAGENT_HOME | awk '{print $2}' |
		while read PID
			do
			echo "Killing $PID ..."
			kill -9 $PID
			echo
			echo "iSaver Event Agent is being shutdowned... "
			done
fi