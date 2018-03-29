# docker-clamav

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-clamav.svg?style=shield&circle-token=d32e28010e795e227e67022da2067733c7fad777)](https://circleci.com/gh/sicz/docker-clamav)

**This project is not aimed at public consumption.
It exists to serve as a single endpoint for SICZ containers.**

A clamav antivirus engine based on [sicz/baseimage-alpine](https://github.com/sicz/docker-baseimage).

## Contents

This container only contains essential components:
* [sicz/baseimage-alpine](https://github.com/sicz/docker-baseimage)
  as a base image.
* [clamav](https://www.clamav.net) provides an antivirus engine.

## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes
on how to deploy the project on a live system.

### Installing

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/sicz/docker-clamav
```

### Usage

Use the command `make` in the project directory:
```bash
make all                      # Build a new image and run the tests
make ci                       # Build a new image and run the tests
make build                    # Build a new image
make rebuild                  # Build a new image without using the Docker layer caching
make config-file              # Display the configuration file for the current configuration
make vars                     # Display the make variables for the current configuration
make up                       # Remove the containers and then run them fresh
make create                   # Create the containers
make start                    # Start the containers
make stop                     # Stop the containers
make restart                  # Restart the containers
make rm                       # Remove the containers
make wait                     # Wait for the start of the containers
make ps                       # Display running containers
make logs                     # Display the container logs
make logs-tail                # Follow the container logs
make shell                    # Run the shell in the container
make test                     # Run the tests
make test-shell               # Run the shell in the test container
make clean                    # Remove all containers and work files
make docker-pull              # Pull all images from the Docker Registry
make docker-pull-baseimage    # Pull the base image from the Docker Registry
make docker-pull-dependencies # Pull the project image dependencies from the Docker Registry
make docker-pull-image        # Pull the project image from the Docker Registry
make docker-pull-testimage    # Pull the test image from the Docker Registry
make docker-push              # Push the project image into the Docker Registry
```

`clamav` listens on TCP port 3310.

## Deployment

You can start with this sample `docker-compose.yml` file:
```yaml
services:
  clamd:
    image: sicz/clamav
    ports:
      - 3310:3310
    volumes:
      - clamav_data:/var/lib/clamav
  freshclam:
    image: sicz/clamav
    command: freshclam --daemon
    depends_on:
      - clamd
    environment:
      - WAIT_FOR_TCP=clamd:3310
    volumes:
      - clamav_data:/var/lib/clamav
volumes:
  clamav_data:
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of
[contributors](https://github.com/sicz/docker-clamav/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.
