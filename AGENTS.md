# AGENTS.md

学習用 Rails アプリ。Cursor と Claude Code で共通の作業指針。

## 環境

- Ruby 2.7.8 / Rails 6.0.6.1 / MySQL 5.7（Docker）
- 回答・生成は Rails 6 向け。グローバルの Rails 8 の書き方を使わない
- コマンドは `bundle exec` 経由
- `rails g` と `db:migrate` は人が打つ。エージェントはコマンドと説明だけ出す
- 生成コードは人が読んで動かしてから次へ進む

## 秘密情報

次はコミットしない。チャットにも貼らない。

- `.env`
- `config/database.yml`
- `config/master.key`

ひな形は `.env.example` と `config/database.yml.example` を使う。

## コミット

- 日本語
- 1行目は「なぜ」を短く（ファイル名の羅列にしない）
- 必要なら本文に理由を 1〜2 文
- 頼まれない限りコミットしない。push も頼まれてから

例:

```
database.yml.example のパスワードデフォルトを Docker に揃える
```

## プルリクエスト

```markdown
## Summary
- （変更の目的を箇条書き）

## Test plan
- [ ] （自分で確認した画面操作・コマンド）
```

## 質問の受け方

ファイルを `@` で付ける。エラーは全文。期待する画面操作は日本語で書く。
