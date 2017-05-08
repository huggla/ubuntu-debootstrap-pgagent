FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd --gid 70 postgres \
 && useradd --create-home --gid 70 pgagent \
 && useradd --create-home --uid 70 --gid 70 postgres \
 && mkdir /run/secrets \
# && touch /run/secrets/postgres-pw \
# && chown postgres:postgres /run/secrets/postgres-pw \
# && chmod u=rwx,go= /run/secrets/postgres-pw \
 && echo -n "*:*:*:*:" > /home/postgres/.pgpass-pre \
 && chown postgres:postgres /home/postgres/.pgpass-pre \
 && chmod u=rwx,go= /home/postgres/.pgpass-pre \
 && touch /home/postgres/.pgpass \
 && chown postgres:postgres /home/postgres/.pgpass \
 && chmod u=rw,go= /home/postgres/.pgpass \
 && echo '#!/bin/sh' > /usr/bin/start-pgagent \
 && chown postgres:postgres /usr/bin/start-pgagent \
 && chmod 6711 /usr/bin/start-pgagent \
 && echo 'read $PASSWORD < /run/secrets/postgres-pw' >> /usr/bin/start-pgagent \
 && echo 'cat /home/postgres/.pgpass-pre /run/secrets/postgres-pw > /tmp/pgpass' >> /usr/bin/start-pgagent \
 && echo 'cat /home/postgres/.pgpass-pre /run/secrets/postgres-pw > /home/postgres/.pgpass' >> /usr/bin/start-pgagent \
 && echo '/usr/bin/pgagent -f hostaddr=$HOSTADDR dbname=$DBNAME user=$USER' >> /usr/bin/start-pgagent \
 && chmod g+r /usr/bin/start-pgagent

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres

VOLUME /run/secrets

USER nobody

CMD ["/usr/bin/start-pgagent"]
