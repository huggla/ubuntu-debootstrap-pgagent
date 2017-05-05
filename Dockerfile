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
 && echo '/usr/bin/pgagent hostaddr=$HOSTADDR dbname=$DBNAME user=$USER password=$PASSWORD' >> /usr/bin/start-pgagent \
 && chmod ugo+r /usr/bin/start-pgagent

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres

VOLUME /run/secrets

CMD /usr/bin/start-pgagent

USER nobody
