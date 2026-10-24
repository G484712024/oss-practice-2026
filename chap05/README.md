# 第5回：Gitの基本操作（add と commit）

## この回で学ぶこと
この回では，Gitの基本的な操作である `git add` と `git commit` について学びます．
これらのコマンドを使うことで，自分の作業を記録し，バージョン管理ができるようになります．

題材として，自己紹介ファイル `PROFILE.md` を書きます．
ここで書いた `PROFILE.md` は，**第6回で生成AI（ChatGPT・Claude・Gemini・Copilot など好きなもの）を使って，HTML/CSSのプロフィールサイトを作るときの素材**になります．
しっかり書いておくほど，次回のサイトがあなたらしくなります．

### 今日のゴール
- [ ] `PROFILE.md` に自己紹介を書き，**2回以上**コミットする
- [ ] `git add` や `git commit` をするたびに，`.git/objects` の中身が増えることを確かめる
- [ ] `git cat-file` でコミットの中身をたどり，自分が書いた自己紹介を取り出す

## Gitとは？
Gitは，ファイルの変更履歴を記録し，管理するためのツールです．
まるでゲームのセーブポイントのように，作業の節目でファイルの状態を保存できます．

Gitでは，ファイルが次の3つの場所を移動していきます．

```
 作業ディレクトリ           ステージングエリア             リポジトリ（.git）
（ファイルを編集する）  ──→ （次のコミットに入れる候補） ──→ （履歴として保存）
                  git add                      git commit
```

- **作業ディレクトリ**：あなたがエディタでファイルを編集する場所
- **ステージングエリア**：「次のコミットに入れるもの」を置いておく場所
- **リポジトリ（`.git` フォルダ）**：コミットした履歴がすべて保存される場所

## 実習の流れ
1. リポジトリを取得する（`git clone`）
2. `.git/objects` の中身を見ておく
3. `PROFILE.md` に基本情報を書く
4. `git status` で変更を確認
5. `git add PROFILE.md` でステージング
6. `git commit -m "基本情報を追加"` でコミット
7. 残りを書いて，もう一度 add → commit
8. `git log --oneline` で履歴を確認
9. `git cat-file` でコミットの仕組みをのぞく

それでは，順番に進めていきましょう．

---

## 1. リポジトリを取得する（git clone）
GitHub上の「Download ZIP」などでファイルをダウンロードすると，リポジトリの履歴やメタデータが入っている `.git` フォルダは含まれません．
そのため，必ず `git clone` でリポジトリをクローンしてください．

```bash
git clone https://github.com/tomohitoy/oss-practice-2026.git
```

クローンしたフォルダに移動します：
```bash
cd oss-practice-2026
```

いまいるブランチを確認します：
```bash
git branch
```

`* main-05` と表示されればOKです．
違うものが表示された場合は，次のコマンドで第5回用のブランチに移動してください：
```bash
git switch main-05
```

> ブランチについては第6回で詳しく学びます．今は「第5回用の作業場所」と考えておけば大丈夫です．

最後に，この章のフォルダに移動します：
```bash
cd chap05
```

## 2. `.git/objects` の中身を見ておく
Gitは，すべての変更履歴を `.git/objects` というフォルダに保存しています．
あとで比べるために，**何も変更していない今の状態**を見ておきましょう．

```bash
ls ../.git/objects
```

表示例：
```
info
pack
```

**なぜ `../` が付くの？**
`.git` フォルダは，リポジトリの一番上（`oss-practice-2026` フォルダ）にだけあります．
いまは `chap05` フォルダの中にいるので，`..`（1つ上のフォルダ）を付けて指定しています．

クローンした直後は，受け取った履歴がすべて `pack` フォルダの中にまとめて保存されているので，`info` と `pack` しか見えません．
この後，`git add` や `git commit` をするたびに，ここに新しいフォルダが増えていきます．

## 3. `PROFILE.md` に基本情報を書く
VS Code などのエディタで `chap05/PROFILE.md` を開き，まずは **「基本情報」の部分だけ** 書いて保存してください．
残りは手順7で書きます（2回に分けてコミットするためです）．

> **注意**：`PROFILE.md` は，次回AIに渡したり，GitHubで公開したりします．
> フルネームの本名・学籍番号・住所・電話番号など，公開したくない情報は書かないでください（ニックネームでOK）．

## 4. 変更を確認する（`git status`）
どのファイルが変更されているかを確認します．

```bash
git status
```

表示例：
```
On branch main-05
Your branch is up to date with 'origin/main-05'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   PROFILE.md

no changes added to commit (use "git add" and/or "git commit -a")
```

`git status` の表示は，次のように読みます：

| 表示 | 意味 |
| --- | --- |
| `Changes not staged for commit:`（赤字） | 変更したけれど，まだ `git add` していないファイル |
| `Changes to be committed:`（緑字） | `git add` 済みで，コミット待ちのファイル |
| `Untracked files:` | Gitがまだ管理していない，新しく作ったファイル |
| `nothing to commit, working tree clean` | すべての変更がコミット済み |

どこを変更したか詳しく見たいときは，`git diff` を使います（`q` キーで終了）．

## 5. 変更をステージングする（`git add`）
ファイルの変更をコミットする準備をします．これを「ステージング」と言います．

```bash
git add PROFILE.md
```

**ステージングとは？**
ステージングは，写真を撮る前に「どの人を写真に含めるか」を決めるようなものです．
変更したファイルの中から，次のコミットに含めたいものだけを選びます．

> `git add .` と書くと，今いるフォルダ以下のすべての変更をまとめてステージングできます．
> ただし関係ないファイルまで入ってしまうことがあるので，慣れるまではファイル名を指定しましょう．

### 👀 `.git/objects` をのぞいてみよう
```bash
ls ../.git/objects
```

表示例：
```
53
info
pack
```

2文字のフォルダが1つ増えました！
`git add` した瞬間に，Gitは `PROFILE.md` の**中身**を `.git/objects` に保存しています．
このように，ファイルの中身を保存したものを **blob（ブロブ）** と呼びます．

もう一度 `git status` を実行して，`PROFILE.md` が緑字の `Changes to be committed:` に移ったことも確認しましょう．

## 6. 変更を記録する（`git commit`）

### コミットの前に（初回だけ）：名前とメールアドレスの設定
コミットには「誰が変更したか」が記録されます．まず，名前が設定されているか確認しましょう．

```bash
git config --global user.name
```

何も表示されなかった場合は，名前とメールアドレスを設定します．

```bash
git config --global user.name "あなたの名前"
```

```bash
git config --global user.email "あなたのメールアドレス"
```

> ここで設定した名前とメールアドレスは，コミットの中に記録されます（手順9で実際に確認します）．
> GitHubに公開すると誰でも見られるので，公開してよいものを使いましょう．

設定をしないままコミットすると，次の警告が出ます．この警告が出たら，上の設定をしてからもう一度コミットしてください．

```
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.
```

### コミットする
ステージングした変更を，履歴として記録します．

```bash
git commit -m "基本情報を追加"
```

**`-m` オプション**について：
- `-m` は "message"（メッセージ）の略です
- このオプションを使うと，コマンドライン上で直接コミットメッセージを書けます
- メッセージには，「何を変更したか」を簡潔に書きます

**良いコミットメッセージの書き方**：
- 何をしたかを明確に書く
- 日本語でも英語でもOK
- 短く，わかりやすく（1行程度）

### 👀 もう一度 `.git/objects` をのぞいてみよう
```bash
ls ../.git/objects
```

表示例：
```
29
53
63
fe
info
pack
```

今度は3つ増えました．増えたのは次のものです：
- **commit**：コミットそのもの（誰が・いつ・なぜ変更したか）
- **tree**：フォルダの中身の一覧（`chap05` フォルダ用と，リポジトリ全体用の2つ）

つまり，**`git add` で中身（blob）が保存され，`git commit` でそれをまとめる tree と commit が作られる**，という仕組みになっています．

### コミット後の `git status`
```bash
git status
```

表示例：
```
On branch main-05
Your branch is ahead of 'origin/main-05' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
```

`ahead of 'origin/main-05' by 1 commit` は，「GitHub上のリポジトリより，あなたのパソコンのほうが1コミット進んでいる」という意味です．
コミットは，まだあなたのパソコンの中にだけ保存されています（GitHubに送る `git push` は第7回で学びます）．

## 7. 残りを書いて，もう一度コミットする
`PROFILE.md` の残りの項目（キャッチコピー，趣味，プログラミング経験など）を書いて保存したら，もう一度同じ流れでコミットします．

```bash
git status
```

```bash
git add PROFILE.md
```

```bash
git commit -m "趣味などを追加"
```

セーブポイントは何回作ってもかまいません．
「項目を1つ書き終えた」など，区切りのいいところでコミットするのがおすすめです．

## 8. コミット履歴を見る（`git log`）

### `git log --oneline`
コミット履歴を1行ずつ，簡潔に表示します．

```bash
git log --oneline
```

表示例：
```
89e9b5e 趣味などを追加
6338599 基本情報を追加
e8dea5b 第5回の講義資料を追加
28e28bc Initial commit
```

- 左側の文字列（`89e9b5e`）は「コミットハッシュ」と呼ばれる，コミットを識別するIDです
- 右側はコミットメッセージです
- 上にあるものほど新しいコミットです．下のほうにあるのは，先生が作ったコミットです

> ハッシュの値は，人によって違います．以降の例では，**自分の画面に表示されたハッシュ**に置きかえて実行してください．

### `git log -1`
最新のコミット1件だけを詳しく表示します．

```bash
git log -1
```

表示例：
```
commit 89e9b5e6422d0bfd537bcf687c0a624c24dc3114
Author: Taku Shoku <taku@example.com>
Date:   Sat Oct 24 19:06:40 2026 +0900

    趣味などを追加
```

本当のコミットハッシュは40文字あります．`--oneline` では，その先頭7文字だけを表示しています．

## 9. コミットの仕組みをのぞいてみよう

### 9-1. コミットハッシュと `.git/objects` の関係
コミットハッシュの **先頭2文字** が `.git/objects` の中のフォルダ名，**残りの38文字** がファイル名になっています．

例えば，コミットハッシュが `89e9b5e...` なら：
```bash
ls ../.git/objects/89
```

表示例：
```
e9b5e6422d0bfd537bcf687c0a624c24dc3114
```

`git log -1` で表示された40文字のハッシュと見比べてみましょう．
手順6で増えたフォルダの1つ `63` も，1回目のコミット `6338599` の先頭2文字だったことがわかります．

### 9-2. `git cat-file` でコミットの中身を見る
オブジェクトの種類を確認します：
```bash
git cat-file -t 89e9b5e
```

結果は `commit`，`tree`，`blob`（ファイルの中身）のいずれかになります．ここでは `commit` と表示されます．

コミットの中身を表示します：
```bash
git cat-file -p 89e9b5e
```

表示例：
```
tree a752a0049f31be4560abadbc310fe32632f3d252
parent 63385993454cceba903013ddd49cf2cc5b731083
author Taku Shoku <taku@example.com> 1792836400 +0900
committer Taku Shoku <taku@example.com> 1792836400 +0900

趣味などを追加
```

- **tree**：そのコミット時点でのファイルツリー（フォルダ構造）
- **parent**：1つ前のコミット
- **author**：誰が変更したか（手順6で設定した名前とメールアドレスです）
- **committer**：誰がコミットしたか
- **コミットメッセージ**：なぜ変更したか

> `1792836400` は，1970年1月1日から数えた秒数で表した日時です．

### 9-3. tree → blob とたどって，自分の自己紹介を取り出す
コミットは，次のようにつながっています．

```
commit 89e9b5e「趣味などを追加」
 ├─ tree a752a00 ………… リポジトリ全体のフォルダ
 │    ├─ blob d0daf22   LICENSE
 │    ├─ blob c0d68e6   README.md
 │    └─ tree 3d93078   chap05/
 │         ├─ blob 4f85fe5   PROFILE.md   ← あなたの自己紹介
 │         └─ blob 07ca40d   README.md
 └─ parent 6338599 ……… 1つ前のコミット「基本情報を追加」
```

実際にたどってみましょう．
まず，コミットの `tree` に書かれていたハッシュを見ます：
```bash
git cat-file -p a752a00
```

表示例：
```
100644 blob d0daf22f5c1640c3ac764729f62edce37f550837	LICENSE
100644 blob c0d68e6f0da2f6e6cfed97b74937370c7686dc65	README.md
040000 tree 3d93078e51c26a71c8ae327563f4697e2499f8b9	chap05
```

`blob` はファイル，`tree` はフォルダを表しています．
次に，`chap05` の tree を見ます：
```bash
git cat-file -p 3d93078
```

表示例：
```
100644 blob 4f85fe54643cd789a66121d5dd9a65001548d738	PROFILE.md
100644 blob 07ca40dbab5f2411f3d10f154699f02d1ac5da98	README.md
```

最後に，`PROFILE.md` の blob を見ます：
```bash
git cat-file -p 4f85fe5
```

**あなたが書いた自己紹介が表示されたら成功です！**
コミットとは，「その時点のファイルの中身（blob）」と「フォルダ構造（tree）」をまとめて保存したセーブポイントなのです．

### 9-4. parent をたどって過去にさかのぼる
9-2で表示された `parent` のハッシュを見てみましょう：
```bash
git cat-file -p 6338599
```

1回目のコミット「基本情報を追加」が表示されます．
さらにその `parent` をたどると，先生のコミットまでさかのぼれます．
コミットは，それぞれが1つ前のコミット（parent）を覚えていて，**鎖のようにつながっている**のです．これが「履歴」の正体です．

### 発展：変更していないファイルはどうなっている？
9-4で表示された1回目のコミットの `tree` を見て，9-3で見た2回目のコミットの tree と見比べてみましょう．

```bash
git cat-file -p fe1c447
```

表示例：
```
100644 blob d0daf22f5c1640c3ac764729f62edce37f550837	LICENSE
100644 blob c0d68e6f0da2f6e6cfed97b74937370c7686dc65	README.md
040000 tree 29ea6ed3a19263a06de51d87b56b0a223aac546f	chap05
```

`LICENSE` や `README.md` の blob のハッシュは，2つのコミットで**まったく同じ**です．
一方，`chap05` の tree のハッシュは違います．中にある `PROFILE.md` を書きかえたからです．
Gitは，中身が同じファイルを何度も保存せず，同じ blob を使い回しています．
そのため，何回コミットしてもリポジトリはあまり大きくなりません．

---

## 困ったときは

| 症状 | 原因と対処 |
| --- | --- |
| `ls: ../.git/objects: No such file or directory` | `chap05` フォルダにいない可能性があります．`pwd` で今いる場所を確認しましょう |
| `fatal: not a git repository` | クローンしたフォルダの外にいるか，ZIPでダウンロードしています．手順1からやり直しましょう |
| `git status` で `nothing to commit` と出る | エディタでファイルを保存し忘れていないか確認しましょう |
| `-m` を付け忘れて，見慣れない画面（Vim）が開いた | `Esc` キーを押してから `:q!` と入力し `Enter` で抜けられます．その後，`-m` を付けてやり直しましょう |
| `Author identity unknown` と出る | 手順6の名前とメールアドレスの設定をしましょう |

## まとめ

- **`git status`**：変更されたファイルを確認
- **`git add`**：変更をステージング（コミット準備）．このとき中身が blob として保存される
- **`git commit -m "メッセージ"`**：変更を記録．tree と commit が作られる
- **`git log --oneline`**：コミット履歴を簡潔に表示
- **`git log -1`**：最新のコミットを詳しく表示
- **`ls ../.git/objects`**：Gitのデータ保存場所を確認
- **`git cat-file`**：コミットやファイルの中身を表示（`-t` で種類，`-p` で中身）

これらのコマンドを使いこなせば，Gitの基本操作はバッチリです！

次回は，今日書いた `PROFILE.md` を生成AIに渡して，HTML/CSSのプロフィールサイトを作ります．
