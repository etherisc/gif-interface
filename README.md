![Build](https://github.com/etherisc/gif-interface/actions/workflows/build.yml/badge.svg)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![](https://dcbadge.vercel.app/api/server/cVsgakVG4R?style=flat)](https://discord.gg/Qb6ZjgE8)

# GIF Interface Contracts

This repository holds the necessary interfaces and base contracts to interact with an existing GIF instance.
The repository is not intended to be used on its own.

## Repository settings

The repository uses [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) .
New features/fixes are to be based on the `develop` branch. 
Releases are to be created from the `main` or a `release/` branch. 
Hotfixes on releases are to based on the affected `release/` or the `main` branch. 

Github Actions will automatically publish npm packages (with tag `next`) to npm.js containing the latest contracts. 
The only exception is the `main` branch, which requires manual releases using `npm publish` (without any tags). 

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

## Run linter

Linter findings are shown automatically in vscode. To execute it manually, run the following command:

```bash
solhint contracts/**/*.sol
```
and including _prettier_ formatting 

```bash
solhint --config .solhint.prettier.json contracts/**/*.sol
```

## Publish release to NPMJS

```bash
npm ci 
npm version patch/minor/major --no-git-tag-version
npm publish
git commit -m 'bump version'
```


## Build and test using foundry

Foundry is a new tool to build and test smart contracts. 
More documentation about foundry can be found in the foundry [https://book.getfoundry.sh/](Foundry book).

The project is configured to use foundry. 
All contracts in the `contracts` folder can be compiled using foundry as well as brownie (results are stored in `build_foundry`). 
Foundry tests are writte in solidy and can be found in the `tests_foundry` folder (they need to be separate from brownie based tests).
Dependencies are stored in the `lib` folder and are mapped in the `foundry.yaml` config file.

To compile the contracts using foundry, run the following command:

```bash
forge build
```

To run the foundry based tests, run the following command:

```bash
forge test
```
