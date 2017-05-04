FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 && echo 'pgagent -f -l 1 hostaddr=$HOSTADDR dbname=$DBNAME user=$USER password=$PASSWORD' > /usr/bin/start-pgagent \
 && chmod u=rwxt,go= /usr/bin/start-pgagent

ENV HOSTADDR=''
ENV DBNAME=''
ENV USER=postgres
ENV PASSWORD=''

CMD start-pgagent 
