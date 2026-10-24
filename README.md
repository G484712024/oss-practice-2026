# oss-practice-2026
拓殖大学工学部　2026年度『オープンソースソフトウェア』の実習用リポジトリです

## 講義内容

### [第5回：Gitの基本操作（add と commit）](./chap05/README.md)

Gitの基本的なコマンドである `git add` と `git commit` について学びます．
自己紹介ファイル `PROFILE.md` を書きながら，変更の記録方法や，コミットの仕組みを理解します．
ここで書いた `PROFILE.md` は，第6回で生成AIを使ってプロフィールサイトを作るときの素材になります．

## テスト用環境の立ち上げ

何も設定されていない環境を `docker` を利用することで起動できます．

### docker container のビルド

```bash
docker build -t git-ubuntu .
```

### ubuntu イメージの起動

```bash
docker run -it --rm -v "$(pwd):/work" git-ubuntu
```
