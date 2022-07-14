[![NSF-1948926](https://img.shields.io/badge/NSF-1948926-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1948926)

# Neotoma Database Postgres Container

This repository contains the instructions to build and download a Docker container provides the most recent snapshot of the [Neotoma Paleoecology Database](https://neotomadb.org) in a Posgres RMDS. This container will allow the user to use Postgres and PostGIS capabilities without having to directly install the software on their own computer.

The intended user is a "power user" of the Neotoma Database, who has some familiarity with the database and the database structure, and has taken time to examine the updated [Neotoma Database Manual](). Individuals can connect directly to the container using the commandline `psql` application if they have a local installation of Postgres, using a database GUI such as pgAdmin or DBeaver, or using R or Python.

In each case, the Docker container exposes a port (in the examples below we use port `2022`) on the `localhost` for the database `neotoma`.

The main Docker image is stored in DockerHub (and supported by this public git repository). Associated utilites perform commandline or `psql` operations that are intended to occur periodically. By associating them with this repository and the Docker container we can ensure that any operations do not affect the main Neotoma database, or any of its associated services.

# Container Use

Users can either build the container locally, or pull a pre-compiled image from DockerHub.  Assuming that Docker is currently installed and running on the user's computer, the easiest way to run the container is to use `docker run`. If you do not have an account on DockerHub (and choose not to create one), or if you wish to build the image from scratch locally, you can use the instructions for Building the Image to create and use the container.

## Using `docker run`

If using the DockerHub image, you will need a [Docker account](https://hub.docker.com/) with a username and password.  The `docker run` command will begin by asking for these credentials. The image is hosted on Socorro Dominguez's DockerHub account, [`sedv8808`](https://hub.docker.com/u/sedv8808), and the following commandline arguments will set up the container locally, with Docker running the postgres server, and connecting the container port `5432` (the default Postgres port) to a localhost port `2022`.

```bash
docker run --name test -d -p 2022:5432 -v $PWD/out:/out --rm -e POSTGRES_PASSWORD=postgres sedv8808/neotoma_postgres postgres
```

Information about `docker run` options and tags can be found in the [documentation for `docker run`](https://docs.docker.com/engine/reference/commandline/run/). Here we describe the specific tags used in the above command:

* `-- name` : This is the Docker image name, here we are setting the name to `test`, but this can be changed as needed.
* `-d` : Run the container in the background (detached). This frees up the commandline terminal once the container is started.
* `-p` : Define the localhost port that open container ports will point to. Postgres, by default, uses port `5432`. We use the format `USER`:`CONTAINER`, so this is saying that the user's `localhost:2022` is connected to the container's `localhost:5432`.  You can use `5432:5432` if you wish, but this may cause a conflict if there is a local version of Postgres running.
* `-v` : Link external folders to a folder within the container.  Again we use the `USER`:`CONTAINER` format. Here, the `$PDW/out` folder (`$PWD` representing the current working directory) is linked to the folder `out` within the container.
* `--rm` : Remove the image once it is terminated using `docker stop test`, where `test` is the name defined using the `--name` flag above.
* `-e POSTGRES_PASSWORD` : Within the container set the environment variable `POSTGRES_PASSWORD`, which will be used for the default `postgres` user.

The docker image itself lives at `sedv8808/neotoma_postgres` on DockerHub, and the term `postgres` at the end of the `docker run` command initializes Postgres within the container.

### In Plain English

We take the image at `sedv8808/neotoma_postgres` and build it locally, naming it `test`. Within the container we execute the command `postgres`, which starts the Postgres server. Traffic through the container's port `5432` is connected to the user port `2022`, and all files in the user's `out` folder, are connected to a folder called `/out` inside the container, which allows us to move files out of the container if needed.

## Building the Image Locally

This GitHub repository includes a Dockerfile. If you would rather build the image in your local machine:

* Clone the repository locally using `git clone https://github.com/NeotomaDB/NeotomaPostgres`
* Navigate to the folder using the commandline, and run `docker build -t neotoma_postgres .` 
* With the container now built and stored in your system, run `docker run --name test -d -p 2022:5432 -v $PWD/out:/out --rm -e POSTGRES_PASSWORD=postgres neotoma_postgres postgres`

### Pushing to DockerHub

If you make changes to the Docker container and wish to save the modified image for future use on other computers/servers, you can create a DockerHub account, and create the image remotely using your `<username>` (*e.g.*, `sjgoring`) and a `<tag>` for the image (for example, `mybuild`):

```bash
docker tag neotoma_postgres:latest <username>/neotoma_postgres:<tag>
docker push <username>/neotoma_postgres:<tag>
```

For example:

```
docker push sedv8808/neotoma_postgres:latest
```
