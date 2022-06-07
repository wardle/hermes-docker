# hermes-docker

This is a simple example of how to containerise [hermes](https://github.com/wardle/hermes).

This is an example for the UK. You can build a container by simply passing in your
NHS Digital 'TRUD' api-key.

```shell
docker build . -t eldrix/hermes --build-arg trud_api_key=xxxxxxxx
```

Where xxxxxxxx is your own TRUD API key.

This will download the latest Hermes release, download the UK
SNOMED CT clinical edition, the UK drug extension, and build a container 
that will run a server for you.

I usually use a meaningful tag, with both the version of the software, and the
version of the data included.

```shell
sudo docker build . -t eldrix/hermes-0.12.681--2022-05 --build-arg trud_api_key=xxxxxxxx
```

This creates a container with the software and SNOMED CT data. However, I usually 
prefer to keep my data files on a separate volume, with a container containing only the application code.