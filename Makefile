# docker
.PHONY: build run
build:
	docker build -t latex .
run:
	docker run -it --rm latex /bin/bash

# textlint
.PHONY: fix
fix:
	npx textlint --fix $(filter-out $@,$(MAKECMDGOALS))
