FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd --gid 70 postgres \
 #&& useradd --createpgagent \
 && useradd --create-home --uid 70 --gid 70 postgres \
 && mkdir /run/secrets \
 && touch /run/secrets/.pgpass \
 && chown postgres:postgres /run/secrets/.pgpass \
 && chmod u=r,go= /run/secrets/.pgpass \
 #&& echo -n "*:*:*:*:" > /home/postgres/.pgpass-pre \
 #&& chown postgres:postgres /home/postgres/.pgpass-pre \
 #&& chmod u=rwx,go= /home/postgres/.pgpass-pre \
 #&& touch /home/postgres/.pgpass \
 #&& chown postgres:postgres /home/postgres/.pgpass \
 #&& chmod u=rw,go= /home/postgres/.pgpass \
 #&& echo '#!/bin/sh' > /usr/bin/start-pgagent \
 && chown postgres:postgres /usr/bin/pgagent \
 && chmod 6555 /usr/bin/pgagent
 #&& echo 'read PASSWORD < /run/secrets/postgres-pw' >> /usr/bin/start-pgagent \
 #&& echo 'cat /home/postgres/.pgpass-pre /run/secrets/postgres-pw > /tmp/pgpass' >> /usr/bin/start-pgagent \
 #&& echo 'cat /home/postgres/.pgpass-pre /run/secrets/postgres-pw > /home/postgres/.pgpass' >> /usr/bin/start-pgagent \
 #&& echo '/usr/bin/pgagent -f hostaddr=$HOSTADDR dbname=$DBNAME user=$USER' >> /usr/bin/start-pgagent \
 #&& chmod go+r /usr/bin/start-pgagent

VOLUME /run/secrets

USER postgres

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres
ENV PGPASSFILE=/run/secrets/.pgpass

USER nobody

CMD /usr/bin/pgagent -f hostaddr=$HOSTADDR dbname=$DBNAME user=$USER
