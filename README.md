# GIF Interface Contracts

This repository holds the necessary interfaces and base contracts to interact with an existing GIF instance.
The repository is not intended to be used on its own.

## Clone Repo

```
git clone https://github.com/etherisc/gif-interface.git
cd gif-interface
```

## Fully configure IDE 

To use our fully configured IDE see the instructions at [https://github.com/etherisc/gif-sandbox/blob/master/docs/development_environment.md](https://github.com/etherisc/gif-sandbox/blob/master/docs/development_environment.md). 
In this case you can skip the next two steps as the _devcontainer_ is based on the (updated) _brownie_ image. 


## Create Brownie Docker Image

[Brownie](https://eth-brownie.readthedocs.io/en/stable) is used for development of the contracts in this repository.

Alternatively to installing a python development environment and the brownie framework, wokring with Brownie is also possible via Docker.
For this, build the brownie Docker image as shown below.
The Dockerfile in this repository is a trimmed down version from [Brownie Github]((https://github.com/eth-brownie/brownie))

```bash
docker build -t brownie .
```

## Run Brownie Container

```bash
docker run -it --rm -v $PWD:/projects brownie
```

## Compile the GIF Interface Contracts

Inside the brownie container compile the contracts/interfaces

```bash
brownie compile --all
```
