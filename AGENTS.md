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

## テンプレート

`app/views` はHamlに統一済み（メーラーのデフォルトテンプレートのみERB）。新規ビューは2スペースインデントのHamlで書く。タブとスペースを混ぜない。人は生成結果の入れ子を読んでから次へ進む。

## コードレビュー

指摘・セルフレビューは次の観点に合わせる。

https://github.com/yutaroharadacl/ss_rails_practice/blob/ac93de14644b3f2a3e3ad1cbbfab2979122b14a3/docs/rails_review_checklist.md

特に: flash は I18n、`find` の `RecordNotFound` をユーザー向けに扱う、リダイレクト先は明示、成功・失敗の両方で画面にメッセージを出す。新規の `create_table` は `up` / `down` と `data_source_exists?`。

## 質問の受け方

ファイルを `@` で付ける。エラーは全文。期待する画面操作は日本語で書く。
