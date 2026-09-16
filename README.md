# ss_rails_practice


## いま入っている技術スタック
| 項目 | 内容 |
|---|---|
| Ruby | 2.7.8（`.ruby-version` / rbenv） |
| Rails | 6.0.6.1 |
| アプリサーバ | Puma 4.3 |
| DB | MySQL 5.7（Docker のみ。文字コード `utf8mb4`） |
| テンプレート | 既存画面は ERB。カート以降の新規ビューは Haml（`haml-rails` / Haml 6） ※後工程で修正予定|
| JavaScript | Sprockets + `rails-ujs` + Turbolinks |

`concurrent-ruby` は `1.3.4` に固定している。1.3.5 以降は Rails 6.0 で `Logger` 関連のエラーになる。


## セットアップ

必要なもの: rbenv（Ruby 2.7.8）、Bundler 2.4.22、Docker Desktop

### 1. リポジトリ

```bash
cd ss_rails_practice
ruby -v    # ruby 2.7.8
```


### 2. gem

```bash
gem install bundler -v 2.4.22
bundle _2.4.22_ install
```

### 3. MySQL（Docker）


```bash
open -a Docker
docker compose up -d
docker compose ps
```

初回は `linux/amd64` の MySQL 5.7 をエミュレーションで動かす。`utf8mb4` は compose と `docker/mysql/init.sql` で指定している。


停止:

```bash
docker compose down
```

データも含めて消す:

```bash
docker compose down -v
```

### 4. データベースと起動

```bash
bin/rails db:create
bin/rails db:migrate
bundle exec rails server
```

確認: `http://localhost:3000`

ポートが埋まっている場合:

```bash
bundle exec rails server -p 3001
```
