.PHONY: all
.EXPORT_ALL_VARIABLES:
CONTAINER_NAME = vrising
CONTAINER_VERSION = 0.0.1

all: run

build_dev:
	docker build . \
		-t ${CONTAINER_NAME}:${CONTAINER_VERSION} \
		--no-cache

build_prod:
	docker build . \
		-t ${CONTAINER_NAME}:${CONTAINER_VERSION} \
		-t ${CONTAINER_NAME}:latest \
		--no-cache

run:
	docker run \
		-dit \
		--name vrising \
		-v $(pwd)/Saves:/app/Saves \
		-p 9876:9876/udp \
		-p 9877:9877/udp \
	vrising:latest
