# Introduction

Docker image for running the serverless command without requiring it to be installed.

## Installation

Ensure you have a .npm directory for caching dependancies (`mkdir -p ~/.npm`)

Add the following lines to your `~/.bashrc` file to be able to run it easily...

```
alias node-run='docker run --rm -p 3000:3000 -p 3002:3002 -it --volume ~/.npm:/home/node/.npm --volume $PWD:/app aligent/serverless'
alias serverless='node-run serverless'
```

You will then need to reload your bashrc file, either by running `. ~/.bashrc` or starting a new terminal session.

## Usage

You can now run serverless normally.

To create a new project for example:

```
serverless create --template aws-nodejs --path test-service
```

