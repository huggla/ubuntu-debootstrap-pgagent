FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 #&& useradd -m pgagent \
 && mkdir /run/secrets \
 && touch /run/secrets/postgres-pw \
 && chmod u=r,go= /run/secrets/postgres-pw \
 && echo '#!/bin/sh' > /usr/bin/start-pgagent \
 #&& chown root:pgagent /usr/bin/start-pgagent \
 && chmod 6711 /usr/bin/start-pgagent \
 && echo 'read PASSWORD < /run/secrets/postgres-pw' >> /usr/bin/start-pgagent \
 && echo 'chpst -u nobody -b argv0 -b argv1 /usr/bin/pgagent -f "hostaddr=$HOSTADDR dbname=$DBNAME user=$USER password=$PASSWORD"' >> /usr/bin/start-pgagent \
 && chmod ugo+r /usr/bin/start-pgagent

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres

VOLUME /run/secrets

USER nobody

CMD ["/usr/bin/start-pgagent"]


