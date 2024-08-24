# docker
.PHONY: build.tex build.pdf
build.tex:
	docker build . -t latex -f dockerfiles/texlive/Dockerfile

build.pdf:
	docker build . -t pdf -f dockerfiles/pdf-to-image/Dockerfile

run.pdf:
	docker run --rm -v $(pwd):/pdf pdf $(filter-out $@,$(MAKECMDGOALS)) output -png

# textlint
.PHONY: fix
fix:
	npx textlint --fix $(filter-out $@,$(MAKECMDGOALS))
