# hermes-docker

This repository gives examples of how to containerise [hermes](https://github.com/wardle/hermes).

`hermes` is a SNOMED CT terminology server. 

The application makes use of file-based databases which, in operation, are read-only and may well fit 
into the available memory of a decent server. That makes its operation very fast.
It is also quite suitable for use as a container even on memory-constrained servers.

So, deploying `hermes` requires us to build (or run directly), the application and to build the file-based
databases.

Unfortunately I cannot re-distribute pre-built databases due to SNOMED licensing. But, `hermes` makes
it easy to build your own. You can do this using the `hermes` command-line tools, or run the example
Docker build processes below. I prefer to use the command-line tools.


### Examples

Here are a number of examples 

#### uk-combined

This is an example for the UK in which we build a container containing both
application code and the data files needed. This build downloads the source code,
compiles a jar file, downloads the latest UK distribution, installs it and creates
a container that will run your server. You can specify the version of `hermes` and 
the release date of SNOMED CT to use. 

I do not recommend using this build process for general usage. Apart from the caching provided by Docker, 
it cannot cache intermediary downloaded data files. Docker caching will not work if, for example, 
you update the version of `hermes` and so the build process will be forced to re-download the whole of SNOMED CT again.
However, it is convenient if you simply want to see how it works!

You can build a container by simply passing in your NHS Digital 'TRUD' api-key.

```shell
docker build . --file uk-combined.Dockerfile -t eldrix/hermes-0.12.681--uk-2022-05 --build-arg trud_api_key=xxxxxxxx
```

Where xxxxxxxx is your own TRUD API key.

This will download the latest Hermes release, download the UK
SNOMED CT clinical edition, the UK drug extension, and build a container
that will run a server for you.

I recommend using a meaningful tag, with both the version of the software, and the
version of the data included. You will see I am building a container containing both 
the version of `hermes` and the SNOMED release date used. 

This is most useful when you are experimenting with `hermes`, although I might
suggest it is easier (and quicker) to simply use the jar file from the command
line, or run from source code using the clojure command line tools.
However, I usually prefer to keep my data files on a separate volume, with a 
container containing only the application code. That means a single volume 
can potentially be shared, and given the use of memory-mapping, not require 
additional memory but make the best use of multiple processors by making use
of multiple containers running the application.

#### from-local

This is a very simple Dockerfile that presupposes that you have used the `hermes`
command line utilities to build an uberjar and to create the necessary data files.

Assuming you have done so, with the `hermes` github repository cloned to ~/Dev/hermes, 
simply run:

```shell
sudo docker build ~/Dev/hermes --file from-local.Dockerfile --build-arg hermes_jar=target/hermes-0.12.681.jar --build-arg snomed_db=snomed.db
```