FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update && apt-get install -y pgagent

ENV CONNECT_STRING=''

CMD pgagent -f -l 1 $CONNECT_STRING 
