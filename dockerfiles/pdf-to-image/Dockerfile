FROM debian:12.6-slim

RUN apt update && apt install --no-install-recommends -y \
  poppler-utils \
  poppler-data \
  imagemagick \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /pdf

CMD ["bash"]
