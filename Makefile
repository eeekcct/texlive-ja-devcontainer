# docker
.PHONY: build.tex build.pdf
build.tex:
	docker build . -t latex -f dockerfiles/texlive/Dockerfile

build.pdf:
	docker build . -t pdf -f dockerfiles/pdf-to-image/Dockerfile

buildx.pdf:
	docker buildx build \
		--cache-from=type=local,src=/tmp/.buildx-cache \
		--cache-to=type=local,dest=/tmp/.buildx-cache \
		--output=type=docker \
		. -t pdf -f dockerfiles/pdf-to-image/Dockerfile

run.pdf:
	docker run --rm -v $(shell pwd):/pdf pdf bash -c \
		"pdftoppm -png $(filter-out $@,$(MAKECMDGOALS)) output"

compare:
	docker run --rm -v $(shell pwd):/pdf pdf bash -c \
		"compare -metric RMSE $(filter-out $@,$(MAKECMDGOALS)) diff-1.png"

# textlint
.PHONY: fix
fix:
	npx textlint --fix $(filter-out $@,$(MAKECMDGOALS))
