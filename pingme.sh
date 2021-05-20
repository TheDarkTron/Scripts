#!/bin/bash

usr=pac06
fail=0

# www1 router2 router3 www2
for host in 10.7.106.3 10.7.106.4 10.7.106.66 10.7.106.98
do
	ssh_cmd="ssh -q $usr@$host"

	hostna=$($ssh_cmd "hostname")
	if [ "$?" -eq 0 ];
	then
		echo Connected to $hostna
    	
		for target in router1 www1 router2 router3 www2
	    do
		    # ping with IPv4
		    $ssh_cmd "ping -4 -c 3 $target > /dev/null"

		    if [ "$?" -eq 0 ];
		    then
    			echo IPv4 ping successful to $target
			else
				echo IPv4 ping failed to $target
				fail=1
			fi

			# ping with IPv6
			# skip IPv6 ping to localhost
			[ $target = $($ssh_cmd hostname) ] && continue

			$ssh_cmd "ping -6 -c 3 $target > /dev/null"

			if [ "$?" -eq 0 ];
			then
				echo IPv6 ping successful to $target
			else
				echo IPv6 ping failed to $target
				fail=1
			fi
		done
	
	else
		echo Could not connect to $host
	fi

	echo ""
done

exit $fail
