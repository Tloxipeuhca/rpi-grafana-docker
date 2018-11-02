.PHONY: all build push test version
include VERSION.env

DOCKER_IMAGE_VERSION=$(VERSION)
DOCKER_IMAGE_NAME=tloxipeuhca/rpi-grafana-docker

all: build

build:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --build-arg GF_VERSION=$(DOCKER_IMAGE_VERSION) .
	docker build -t $(DOCKER_IMAGE_NAME):latest --build-arg GF_VERSION=$(DOCKER_IMAGE_VERSION) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME) /bin/echo "Success."

push:
	docker push $(DOCKER_IMAGE_NAME)

