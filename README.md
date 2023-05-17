![Docker Pulls](https://img.shields.io/docker/pulls/aligent/serverless)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/aligent/serverless?sort=semver)

# Introduction

Docker image for running the serverless command without requiring it to be installed. It is available on docker 
hub as [aligent/serverless](https://hub.docker.com/r/aligent/serverless).

## Installation

Add the following lines to your `~/.bashrc` or `~./.zshrc` file to be able to run it easily...

```
alias node-run='docker run --rm -it --volume ~/.aws:/home/node/.aws --volume ~/.azure:/home/node/.azure --volume ~/.npm:/home/node/.npm --volume "$PWD:/app" aligent/serverless'
alias serverless='node-run serverless'
```

You will then need to reload your bashrc/zshrc file, either by running `. ~/.bashrc` or starting a new terminal session.

## Usage

You can now run serverless normally.

To create a new project for example:

```
serverless create --template aws-nodejs --path test-service
```

## Automatic image switching
To automatically switch between different node versions based on your current directories `.nvmrc` file you can add the following function to your `~/.bashrc` or `~/.zshrc` and update the `node-run` alias as below.

```
determine_serverless_image() {
    if [ -n "$ZSH_VERSION" ]; then 
        setopt local_options BASH_REMATCH # for ZSH compatiblity
        setopt local_options KSH_ARRAYS # for ZSH compatiblity
    fi

    DEFAULT_IMAGE='aligent/serverless:latest'
    NVM_RC=$(realpath .nvmrc)

    if [ -s "$NVM_RC" ]; then 
        NODE_VERSION=$(<"$NVM_RC")

        if [[ $NODE_VERSION =~ ^v?([0-9]+)(\.[0-9]+)?(\.[0-9]+)?$ ]]; then
            echo "aligent/serverless:latest-node${BASH_REMATCH[1]}"
            return 0
        fi
    fi

    echo $DEFAULT_IMAGE
    return 0
}

alias node-run='docker run --rm -it --volume ~/.aws:/home/node/.aws --volume ~/.azure:/home/node/.azure --volume ~/.npm:/home/node/.npm --volume $PWD:/app $(determine_serverless_image)'
```
