FROM blitznote/debootstrap-amd64:16.04

RUN apt-get update \
 && apt-get install -y pgagent \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --create-home --user-group --uid 70 --gid 70 postgres \
 && mkdir /run/secrets \
 && touch /run/secrets/postgres-pw \
 && chmod u=r,go= /run/secrets/postgres-pw \
 && echo '#!/bin/sh' > /usr/bin/start-pgagent \
 && chown postgres:postgres /usr/bin/start-pgagent \
 && chmod 6755 /usr/bin/start-pgagent \
 && echo 'mkfifo --mode=600 /home/postgres/.pgpass { echo "*:*:*:*:"`cat /run/secrets/postgres-pw` } >/home/postgres/.pgpass &' >> /usr/bin/start-pgagent \
 && echo '/usr/bin/pgagent -f hostaddr=$HOSTADDR dbname=$DBNAME user=$USER' >> /usr/bin/start-pgagent \
 && echo 'rm /home/postgres/.pgpass' >> /usr/bin/start-pgagent

ENV HOSTADDR=''
ENV DBNAME=postgres
ENV USER=postgres

VOLUME /run/secrets

USER nobody

CMD ["/usr/bin/start-pgagent"]
