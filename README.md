# Neotoma Docker and Bash utilities

This repository represents a set of utilities, supported by a Docker image of the Neotoma Database.

The repository is designed around a workflow in which a Docker image is created using the "latest" version of the Neotoma database, using a snapshot hosted on the [Neotoma Database Snapshots page](https://neotomadb.org/snapshots).

The main Docker image is stored in DockerHub (and supported by this public git repository). Associated utilites perform commandline or `psql` operations that are intended to occur periodically. By associating them with this repository and the docker container we can ensure that any operations do not affect the main Neotoma database, or any of its associated services.

# To Use Directly from the DockerHub

```
docker run --name test -d -p 2022:5432 -v $PWD/out:/out --rm -e POSTGRES_PASSWORD=postgres sedv8808/neotoma_postgres postgres
```
* Currently using sedv8808 Docker user.

Note that the tags we are using can be modified:
`-- name` : Choose the name of your preference. We are setting the name to `test`.
`-p` : Port where we want to connect to. You can choose the number you want on the left side of the `:` but `5432` should be used on the right side.
`-v` : Mount the volume to our current path for any exports.
`--rm` : Remove the image once we finish using it
`-e POSTGRES_PASSWORD` : This is an environment variable, you can choose whichever password you want. We are setting it to `postgres`.

# To Build the Image
This GitHub repository includes a Dockerfile. If you would rather build the image in your local machine, use the following instructions:

1. To build the container clone or download this repository.
2. Navigate on your Terminal or bash to the root directory of this repository.
3. Run the following command:
```
docker build -t neotoma_postgres .
```
You can name the tag anything you want, we have chosen `neotoma_postgres`
4. Run the container using:
```
docker run --name test -d -p 2022:5432 -v $PWD/out:/out --rm -e POSTGRES_PASSWORD=postgres neotoma_postgres postgres
```

If you would like to modify your image and push it to the DockerHub, you also need to do the next steps:
1. Make sure you are logged in to Docker via the terminal
```
docker login -u <username> -p <password>
```
2. Tag the image, the new tag must include your Docker username.
```
docker tag neotoma_postgres:latest <username>/neotoma_postgres:<a tag>
```
For example:
```
docker tag neotoma_postgres:latest sedv8808/neotoma_postgres:latest
```
3. Push the image
```
docker push <username>/neotoma_postgres:<a tag>
```
For example:
```
docker push sedv8808/neotoma_postgres:latest
```

This Docker image rebuilds the database using the latest snapshot of the Neotoma Database.
This snapshot of the public version neotoma database was generated from PostgreSQL version 9.6.24.

The Dockerfile and regenbash.sh script run the following installation instructions.
