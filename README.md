# hermes-docker

This repository gives examples of how to containerise [hermes](https://github.com/wardle/hermes).

### Examples

#### uk-combined

This is an example for the UK in which we build a container containing both
application code and the data files needed.

You can build a container by simply passing in your NHS Digital 'TRUD' api-key.

```shell
docker build . -t eldrix/hermes --build-arg trud_api_key=xxxxxxxx
```

Where xxxxxxxx is your own TRUD API key.

This will download the latest Hermes release, download the UK
SNOMED CT clinical edition, the UK drug extension, and build a container
that will run a server for you.

I recommend using a meaningful tag, with both the version of the software, and the
version of the data included.

```shell
sudo docker build . -t eldrix/hermes-0.12.681--uk-2022-05 --build-arg trud_api_key=xxxxxxxx
```

This creates a container with the software and SNOMED CT data.

This is most useful when you are experimenting with `hermes`, although I might
suggest it is easier (and quicker) to simply use the jar file from the command
line, or run from source code using the clojure command line tools.
However, I usually prefer to keep my data files on a separate volume, with a 
container containing only the application code. That means a single volume 
can potentially be shared, and given the use of memory-mapping, not require 
additional memory but make the best use of multiple processors by making use
of multiple containers running the application.

####