![Docker Pulls](https://img.shields.io/docker/pulls/aligent/serverless)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/aligent/serverless?sort=semver)

# Introduction

Docker image for running the serverless command without requiring it to be installed. It is available on docker 
hub as [aligent/serverless](https://hub.docker.com/r/aligent/serverless).

## Installation

Add the following lines to your `~/.bashrc` file to be able to run it easily...

```
alias node-run='docker run --rm -it --volume ~/.aws:/home/node/.aws --volume ~/.azure:/home/node/.azure --volume ~/.npm:/home/node/.npm --volume "$PWD:/app" aligent/serverless'
alias serverless='node-run serverless'
```

You will then need to reload your bashrc file, either by running `. ~/.bashrc` or starting a new terminal session.

## Usage

You can now run serverless normally.

To create a new project for example:

```
serverless create --template aws-nodejs --path test-service
```

