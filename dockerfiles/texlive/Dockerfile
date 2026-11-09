FROM node:24-bookworm-slim

RUN apt update && apt install --no-install-recommends -y \ 
  wget \
  unzip \
  perl \
  # latexindent が動作するために必要な Perl モジュール
  libyaml-tiny-perl \
  libfile-homedir-perl \
  convmv \
  make \
  locales \
  ca-certificates \
  gnupg \
  # collection-langjapanese インストール時に必要なパッケージ
  # xetex: error while loading shared libraries: libfontconfig.so.1: cannot open shared object file: No such file or directory
  libfontconfig \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# ロケールを設定と環境変数を設定
RUN sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen
ENV LANG=ja_JP.UTF-8

# texlive のインストール
WORKDIR /tmp

COPY ./texlive.profile /tmp

# The installer release is fixed; packages still come from the live tlnet repository.
ARG TEXLIVE_YEAR=2026
# Renovate changes this marker to rebuild TeX layers. It is not a package lock.
ARG TEXLIVE_TLNET_SHA512=f7c90c78376245b0bed91ff10a6d19d7e3c48099f61349e2419d492b0ce8357519734a38d5a27d1af937a3c6c6fe8f751ae5c5a2463b66cf60f57d14e5a981d4

RUN printf '%s\n' "${TEXLIVE_TLNET_SHA512}" | grep -Eq '^[0-9a-f]{128}$' \
  && wget "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${TEXLIVE_YEAR}/install-tl-unx.tar.gz" \
  && tar xvf install-tl-unx.tar.gz \
  && grep -Eq "^TeX Live .* version ${TEXLIVE_YEAR}$" ./install-tl-*/release-texlive.txt \
  && ./install-tl-*/install-tl -profile ./texlive.profile -verify-downloads \
  && rm -rf /tmp/*

# 環境変数を設定
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive

ENV PATH="/usr/local/bin/texlive:$PATH"

# 必要なパッケージをインストール
RUN tlmgr --verify-repo=all update --self --all

RUN tlmgr --verify-repo=all install collection-fontsrecommended collection-langjapanese
  # 時間がかかるのでコメントアウト
  # collection-latexextra latexmk

# 追加パッケージのインストール
RUN tlmgr --verify-repo=all install cite multirow caption fancybox siunitx mhchem titlesec chemgreek

WORKDIR /latex
