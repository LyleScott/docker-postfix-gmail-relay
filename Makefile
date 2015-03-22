APPNAME="postfix-gmail-relay"
LINKNAME="gmailrelay"
HOST_PORT=9025
CONTAINER_PORT=25

build:
	docker build -t lylescott/${APPNAME} .

run:
	docker run -i -t --rm \
        --name ${LINKNAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
        lylescott/${APPNAME}

shell:
	docker run -i -t --rm \
        --name ${LINKNAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
        lylescott/${APPNAME} /bin/bash

clean:
	docker rmi -f lylescott/${APPNAME}
	#echo $(docker images | grep '<none>' | awk '{print $3}' | xargs)
	#docker rmi -f $(docker images | grep '<none>' | awk '{print $3}' | xargs) 
