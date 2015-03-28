APPNAME="postfix-gmail-relay"
LINKNAME="gmailrelay"
HOST_PORT=9025
CONTAINER_PORT=25

build:
	docker build -t lylescott/${APPNAME} .

run:
	# Supply EMAIL and EMAILPASS as environment variables.
	docker run -i -t --rm \
        --name ${LINKNAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
		-e SYSTEM_TIMEZONE="America/New_York" \
		-e MYNETWORKS="10.0.0.0/8 192.168.0.0/16 172.0.0.0/8" \
		-e EMAIL="terminal.bound@gmail.com" \
		-e EMAILPASS="$(EMAILPASS)" \
        lylescott/${APPNAME}

shell:
	docker run -i -t --rm \
        --name ${LINKNAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
		-e SYSTEM_TIMEZONE="America/New_York" \
		-e MYNETWORKS="10.0.0.0/8 192.168.0.0/16 172.0.0.0/8" \
		-e EMAIL="terminal.bound@gmail.com" \
		-e EMAILPASS="$(EMAILPASS)" \
        lylescott/${APPNAME} /bin/bash

daemon:
	docker run -i -t --rm -d \
        --name ${LINKNAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
		-e SYSTEM_TIMEZONE="America/New_York" \
		-e MYNETWORKS="10.0.0.0/8 192.168.0.0/16 172.0.0.0/8" \
		-e EMAIL="terminal.bound@gmail.com" \
		-e EMAILPASS="$(EMAILPASS)" \
        lylescott/${APPNAME}

clean:
	docker rmi -f lylescott/${APPNAME}
	#echo $(docker images | grep '<none>' | awk '{print $3}' | xargs)
	#docker rmi -f $(docker images | grep '<none>' | awk '{print $3}' | xargs) 
