#!/bin/sh

#Set nick
nickname="changeme"

#Set weechat redhat profile name
server_name="changeme"

#Set Weechat FIFO
fifo_api=`find $HOME/.weechat -name weechat_fifo_*`

function change_nick(){
    echo "irc.server.${server_name} */nick $1" > ${fifo_api}
	lastnick=$1
	}

i=1
dbus-monitor --session interface='org.freedesktop.Notifications',member='Notify'|
while read -r line; do

		if [[ ${line} =~ .*Talking.* ]]
			then
			   change_nick "${nickname}|call"

		elif [[ ${line} =~ .*Idle.* ]] && [[ ${lastnick} != "${nickname}" ]]
			then
			   change_nick "${nickname}"
		
	    elif [[ ${line} == 'string "Current status is: Ready"' ]] && [[ ${lastnick} != ${nickname} ]]
			then 
				change_nick "${nickname}"
		fi
done
