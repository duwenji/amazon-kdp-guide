# 01. 原稿準備（AZW3 ファイル生成）

## 📖 このセクションで学べること

このセクションを読むと、以下が理解できます：

- ✅ Markdown から AZW3 への正しい変換方法
- ✅ CSS スタイル設定とレイアウト
- ✅ メタデータ（タイトル、著者、説明）の設定
- ✅ 目次（TOC）の生成
- ✅ 品質チェック（Kindle Previewer での確認）
- ✅ よくあるフォーマットエラーと解決方法

**学習時間**: 約 30 分

---

## 🎯 原稿準備の全体フロー

```
① Markdown 原稿を確認
  ↓
② メタデータを設定（metadata.yaml）
  ↓
③ CSS スタイルを調整（style.css）
  ↓
④ 変換ツール実行（convert-to-kindle.ps1）
  ↓
⑤ AZW3 / EPUB ファイルを生成
  ↓
⑥ Kindle Previewer で確認
  ↓
⑦ KDP にアップロード
```

---

## 📝 ステップ 1: Markdown 原稿の準備

### **ファイル構成の確認**

clean-architecture の例：

```
clean-architecture/
├── 01-introduction/
│   ├── 01-overview.md
│   ├── 02-why-clean-architecture.md
│   └── 03-key-concepts.md
├── 02-core-principles/
│   ├── 01-single-responsibility.md
│   ├── 02-open-closed.md
│   └── ...
└── ...
```

### **Markdown ファイルのフォーマット要件**

| 要件 | 詳細 |
|------|------|
| **文字エンコーディング** | UTF-8 |
| **改行コード** | LF (Unix 形式) |
| **ファイル名** | 01-*, 02-* (ソート順が大切) |
| **見出し** | # H1, ## H2, ### H3 を適切に使用 |
| **画像** | 相対パスで参照（.png / .jpg / .gif） |
| **リンク** | 相対パスまたは URL |

### **チェックリスト**

```
☐ すべての Markdown ファイルが UTF-8 で保存されている
☐ ファイル名の番号順が正しい（01-, 02-, 03-...）
☐ 見出しが階層化されている（H1 は最上位のみ）
☐ 不要な空白行や余分な改行がない
☐ 画像ファイルが正しくフォルダに配置されている
☐ 外部リンクは全て有効
```

---

## 🎨 ステップ 2: メタデータの設定

### **metadata.yaml の作成と編集**

このファイルで書籍の基本情報を定義します。

```yaml
# 書籍の基本情報
title: "クリーンアーキテクチャ完全ガイド"
subtitle: "実践的な設計パターンとベストプラクティス"
author: "あなたの名前"
publisher: "あなたの出版社名"
language: "ja"  # 日本語

# 説明
description: >
  クリーンアーキテクチャの基本から応用まで、
  実装例とベストプラクティスを詳しく解説した完全ガイドです。
  SOLID 原則、デザインパターン、レイアーの分離方法を学べます。

# ISBN（Kindle では不要、紙の本の場合は必須）
isbn: "978-1-234567-89-0"  # 紙の本の場合のみ

# 出版日
published_date: "2026-03-20"

# キーワード
keywords:
  - クリーンアーキテクチャ
  - ソフトウェア設計
  - SOLID 原則
  - デザインパターン
  - 実装ガイド

# カバー画像
cover_image: "./cover.png"

# 言語
lang: "ja"

# よみがな（日本語の場合）
author_yomi: "あなたのなまえ"
title_yomi: "くりーんあーきてくちゃかんぜんがいど"
```

### **メタデータの重要項目**

| 項目 | 説明 | 例 |
|------|------|-----|
| **title** | 書籍のタイトル（必須） | クリーンアーキテクチャ完全ガイド |
| **author** | 著者名（必須） | 山田太郎 |
| **description** | 書籍説明（KDP で表示） | 50～200字程度 |
| **publisher** | 出版者（KDP で表示） | 個人出版または出版社名 |
| **language** | 言語コード | ja (日本語), en (英語) |

---

## 🎨 ステップ 3: CSS スタイルの設定

### **style.css の例**

Kindle での見た目を定義します：

```css
/* グローバルスタイル */
body {
  font-family: "Noto Sans JP", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  font-size: 1em;
  line-height: 1.6;
  margin: 0;
  padding: 0;
}

/* 見出しスタイル */
h1 {
  font-size: 1.8em;
  font-weight: bold;
  margin: 2em 0 1em 0;
  page-break-before: always;
  border-bottom: 3px solid #333;
  padding-bottom: 0.5em;
}

h2 {
  font-size: 1.4em;
  font-weight: bold;
  margin: 1.5em 0 0.8em 0;
  color: #333;
}

h3 {
  font-size: 1.2em;
  font-weight: bold;
  margin: 1.2em 0 0.6em 0;
  color: #555;
}

/* 段落 */
p {
  margin: 0.8em 0;
  text-align: justify;
}

/* コードブロック */
pre {
  background-color: #f5f5f5;
  border-left: 4px solid #4CAF50;
  padding: 1em;
  margin: 1em 0;
  font-size: 0.85em;
  overflow-x: auto;
}

code {
  font-family: "Monaco", "Courier New", monospace;
  background: #f5f5f5;
  padding: 0.2em 0.4em;
  border-radius: 3px;
}

/* テーブル */
table {
  width: 100%;
  border-collapse: collapse;
  margin: 1em 0;
}

table th,
table td {
  border: 1px solid #ddd;
  padding: 0.5em;
  text-align: left;
}

table th {
  background-color: #f5f5f5;
  font-weight: bold;
}

/* リスト */
ul, ol {
  margin: 1em 0;
  padding-left: 2em;
}

li {
  margin: 0.5em 0;
}

/* 強調 */
strong, b {
  font-weight: bold;
}

em, i {
  font-style: italic;
}

/* 注釈ボックス */
.note {
  background-color: #e3f2fd;
  border-left: 4px solid #2196F3;
  padding: 0.8em;
  margin: 1em 0;
}

.warning {
  background-color: #fff3cd;
  border-left: 4px solid #ffc107;
  padding: 0.8em;
  margin: 1em 0;
}

.success {
  background-color: #d4edda;
  border-left: 4px solid #28a745;
  padding: 0.8em;
  margin: 1em 0;
}
```

---

## 🔄 ステップ 4: 変換ツール実行（Windows PowerShell）

### **convert-to-kindle.ps1 の実行**

```powershell
# c:\dev\apps\clean-architecture で実行

.\.github\skills\ebook-build\scripts\invoke-ebook-build.ps1 `
  -ConfigFile .\.github\skills\ebook-build\configs\clean-architecture.build.json
```

### **変換ツールの役割**

- ✅ Markdown → HTML に変換
- ✅ CSS スタイルを適用
- ✅ メタデータを埋め込み
- ✅ 目次（TOC）を自動生成
- ✅ AZW3 / EPUB / MOBI ファイルを生成

### **出力ファイル**

```
ebook-output/
├── clean-architecture.azw3    ← KDP への推奨フォーマット
├── clean-architecture.epub    ← 汎用電子書籍フォーマット
└── clean-architecture.mobi    ← 旧形式（参考用）
```

---

## 🔍 ステップ 5: Kindle Previewer での確認

### **Kindle Previewer のダウンロード**

公式サイト: https://www.amazon.com/Kindle-Previewer/b?ie=UTF8&node=14624725011

### **プレビューの手順**

1. Kindle Previewer を起動
2. 「File」→「Open」→「clean-architecture.azw3」を選択
3. 「Kindle Paperwhite」デバイスで表示確認

### **確認チェックリスト**

```
☐ 見出しが正しく表示されている
☐ 目次が生成されている
☐ 画像が正しく表示されている
☐ コードブロックのフォーマットが崩れていない
☐ テーブルが正しく表示されている
☐ ページ区切りが自然な箇所にある
☐ 日本語が正しく表示されている（文字化けなし）
☐ リンクが機能している（内部リンク、外部リンク）
```

---

## ❌ よくあるエラーと解決方法

### **エラー 1: 日本語が文字化けする**

**原因**: ファイルエンコーディングが UTF-8 でない

**解決方法**:
```powershell
# PowerShell で UTF-8 に変換
$file = Get-Content -Path "file.md" -Encoding utf8
$file | Out-File -Path "file.md" -Encoding UTF8
```

### **エラー 2: 画像が表示されない**

**原因**: 画像パスが相対パスでない、または支援形式でない

**確認事項**:
- ✅ 画像は PNG, JPG, GIF に対応
- ✅ 相対パスを使用（「./images/photo.png」）
- ✅ 画像サイズが適切（最大 4000x4000px）

### **エラー 3: メタデータが読み込まれない**

**原因**: metadata.yaml の YAML 形式が不正

**対策**:
- ✅ インデント（スペース 2 個）を統一
- ✅ シングルクォート / ダブルクォートを統一
- ✅ YAML バリデーター（online-yaml-validator.appspot.com）で確認

### **エラー 4: 目次が生成されない**

**原因**: Markdown の見出しが H2（##）以下のみ

**対策**:
- ✅ 最上位の見出しは H1（#）を使用
- ✅ 階層構造を正しく設定

---

## 📦 最終チェックリスト

出版前に以下を全て確認してください：

```
原稿品質：
☐ 誤字脱字がない
☐ 改行・段落が自然
☐ 画像が全て埋め込まれている

メタデータ：
☐ タイトルが正確
☐ 著者名が正確
☐ 説明文が読みやすい

フォーマット：
☐ AZW3 ファイルが生成されている
☐ Kindle Previewer で正しく表示される
☐ 目次が生成されている

ライセンス・著作権：
☐ 引用元を明記している
☐ 第三者コンテンツの許可がある
☐ 個人情報が適切に処理されている
```

次のステップ: **02-upload-publish.md** で、KDP への実際のアップロードと出版プロセスを学びます。