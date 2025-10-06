FROM node:24-bookworm-slim

RUN apt update && apt install --no-install-recommends -y \ 
  wget \
  unzip \
  perl \
  cpanminus \
  convmv \
  make \
  locales \
  ca-certificates \
  # collection-langjapanese インストール時に必要なパッケージ
  # xetex: error while loading shared libraries: libfontconfig.so.1: cannot open shared object file: No such file or directory
  libfontconfig \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# ロケールを設定と環境変数を設定
RUN sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen
ENV LANG=ja_JP.UTF-8

# latexindent が動作するために必要なパッケージをインストール
RUN cpanm YAML::Tiny File::HomeDir

# texlive のインストール
WORKDIR /tmp

COPY ./texlive.profile /tmp

RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
  && tar xvf install-tl-unx.tar.gz \
  && ./install-tl-*/install-tl -profile ./texlive.profile \
  && rm -rf /tmp/*

# 環境変数を設定
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive

ENV PATH="/usr/local/bin/texlive:$PATH"

# 必要なパッケージをインストール
RUN tlmgr update --self --all

RUN tlmgr install collection-fontsrecommended collection-langjapanese 
  # 時間がかかるのでコメントアウト
  # collection-latexextra latexmk

# 追加パッケージのインストール
RUN tlmgr install cite multirow caption fancybox siunitx mhchem titlesec chemgreek

WORKDIR /latex
