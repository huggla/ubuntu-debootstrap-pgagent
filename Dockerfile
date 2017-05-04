FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/sh' > /usr/bin/start-pgagent \
 && chmod u=rwx,go=rx /usr/bin/start-pgagent \
 && echo 'read PASSWORD < /run/secrets/postgres-pw' >> /usr/bin/start-pgagent \
 && echo 'pgagent -f -l 1 hostaddr=$HOSTADDR dbname=$DBNAME user=$USER password=$PASSWORD' >> /usr/bin/start-pgagent

VOLUME /run/secrets

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres

CMD ["/usr/bin/start-pgagent"]
