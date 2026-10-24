# ベースとなるイメージを指定
FROM ubuntu:latest

# Gitをインストールする
RUN apt-get update && apt-get install -y \
    git \
    vim \
    less \
&& rm -rf /var/lib/apt/lists/*

# コンテナ内の作業ディレクトリを指定
WORKDIR /work

# コンテナ起動時に実行されるコマンド
CMD ["bash"]
