APPNAME="postfix-gmail-relay"
HOST_PORT=9025
CONTAINER_PORT=25

build:
	docker build --rm=true -t lylescott/${APPNAME} .

run:
	docker run --name ${APPNAME} --rm=true -i -t -p ${HOST_PORT}:${CONTAINER_PORT} lylescott/${APPNAME}

shell:
	docker run --name ${APPNAME} --rm=true -i -t -p ${HOST_PORT}:${CONTAINER_PORT} lylescott/${APPNAME} /bin/bash

clean:
	docker rmi -f lylescott/${APPNAME}
	#echo $(docker images | grep '<none>' | awk '{print $3}' | xargs)
	#docker rmi -f $(docker images | grep '<none>' | awk '{print $3}' | xargs) 
