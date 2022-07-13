# build stage
FROM postgis/postgis as postgres

RUN  apt update \
  && apt install -y wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /dbruns

RUN mkdir dbout
RUN mkdir sql
RUN mkdir out
# Pull in the database:
RUN wget https://www.neotomadb.org/uploads/snapshots/neotoma_ndb_latest.tar --no-check-certificate
RUN tar -xf neotoma_ndb_latest.tar -C ./dbout
RUN gunzip ./dbout/neotoma_ndb_latest.sql.gz

COPY src/* /docker-entrypoint-initdb.d/