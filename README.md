# ss_rails_practice


## 技術スタック
| 項目 | 内容 |
|---|---|
| Ruby | 2.7.8（`.ruby-version` / rbenv） |
| Rails | 6.0.6.1 |
| アプリサーバ | Puma 4.3 |
| DB | MySQL 5.7（Docker のみ。文字コード `utf8mb4`） |
| テンプレート | Haml（`haml-rails`）。メーラーのデフォルトテンプレートのみ ERB |
| JavaScript | Sprockets + `rails-ujs` + Turbolinks + CoffeeScript |
| 認証 | Devise（HTML画面はセッション） + `devise-jwt`（`/api/v1`はJWTトークン認証） |
| 検索 | Ransack |
| テスト | RSpec（`rspec-rails`）+ Capybara / Selenium（system spec） |

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

マイグレーション実行後、既にサーバーを起動していた場合は再起動が必要（DBスキーマの変更は起動中のプロセスには反映されないため）。

## テスト

```bash
bundle exec rspec spec/
```

system spec（`spec/system/`）はヘッドレスChromeを使うため、初回は`selenium-webdriver`/`webdrivers`によるドライバのダウンロードが走る。
