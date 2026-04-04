# 03. ebook-build スキル — 電子書籍の自動ビルド

## 📖 このセクションで学べること

このセクションを読むと、以下が理解できます：

- ✅ `ebook-build` スキルの目的と仕組み
- ✅ 1 コマンドで EPUB / AZW3 / MOBI を生成する方法
- ✅ 実行前の前提条件（Pandoc・Calibre）の確認方法
- ✅ メタデータ・スタイル・出力先のカスタマイズ方法
- ✅ パラメータ一覧と各設定項目の意味

**学習時間**: 約 15 分

> 💡 `01-prepare-manuscript.md` では手動での変換手順を解説しています。  
> このセクションでは、同じ変換処理をスクリプト化した **ebook-build スキル** による自動化を紹介します。

---

## 🎯 ebook-build スキルとは

`ebook-build` は、Markdown で書かれた書籍をワンコマンドで電子書籍（EPUB / AZW3 / MOBI）に変換するための再利用可能なビルドフローです。

このリポジトリの `.github/skills/ebook-build/` フォルダにパッケージ化されており、GitHub Copilot Agent モードから呼び出すことも、PowerShell から直接実行することもできます。

### できること

1. 番号付き Markdown チャプター構造（`01-`, `02-` ...）からコンテンツを収集
2. 専用の **メタデータ**・**スタイルシート** を適用して EPUB を生成
3. Calibre 経由で AZW3 / MOBI へ変換
4. EPUB page-list ナビゲーションを自動注入（Kindle 互換性向上）
5. 成果物を `ebook-output/` に出力

### スキルのファイル構成

```text
.github/skills/ebook-build/
├── SKILL.md                                  ← Skill 定義（Copilot 向け）
├── EBOOK_BUILD_SPECIFICATION.md              ← 実装仕様
├── VALIDATION_CHECKLIST.md                   ← 検証チェックリスト
├── configs/
│   ├── amazon-kdp-guide.build.json           ← このリポジトリ用の実行設定
│   ├── amazon-kdp-guide.metadata.yaml        ← 書籍メタデータ
│   └── github-copilot-skills-tutorial.build.json
├── assets/
│   └── style.css                             ← EPUB スタイルシート
├── docs/
│   ├── README.md                             ← 実行ガイド（詳細版）
│   └── KINDLE-COMPATIBILITY-CHECKLIST.md     ← Kindle 互換性チェック
└── scripts/
    ├── invoke-ebook-build.ps1                ← 実行エントリポイント
    ├── convert-to-kindle.ps1                 ← 変換コア
    └── add-pagelist-functions.ps1            ← page-list 補助
```

---

## 🔧 前提条件

実行前に以下の 2 つのツールがインストールされていることを確認してください。

### Pandoc

Markdown → EPUB 変換に使用します。

```powershell
pandoc --version
```

インストール: https://pandoc.org/installing.html

### Calibre（AZW3 / MOBI を生成する場合）

EPUB → AZW3 / MOBI 変換に使用します。

```powershell
ebook-convert --version
```

インストール: https://calibre-ebook.com/download

---

## 🚀 実行方法

### 最短実行（設定ファイル指定）

このリポジトリには設定ファイルが用意されているため、以下の 1 コマンドで実行できます。

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills\ebook-build\scripts\invoke-ebook-build.ps1 `
  -ConfigFile .\.github\skills-config\ebook-build\amazon-kdp-guide.build.json
```

### パラメータを直接指定する場合

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills\ebook-build\scripts\invoke-ebook-build.ps1 `
  -SourceRoot "." `
  -OutputDir ".\ebook-output" `
  -ProjectName "amazon-kdp-guide" `
  -Formats @("epub", "azw3", "mobi")
```

---

## ⚙️ パラメータ一覧

| パラメータ | 必須 | 既定値 | 説明 |
|---|---|---|---|
| `SourceRoot` | ✅ | — | チャプターフォルダを含むルートディレクトリ（またはそれ以下の docs/ ルート） |
| `OutputDir` | — | `<SourceRoot>/ebook-output` | 成果物の出力先フォルダ |
| `ProjectName` | — | `SourceRoot` のフォルダ名 | 出力ファイル名のベース（例: `amazon-kdp-guide`） |
| `Formats` | — | `["epub", "azw3", "mobi"]` | 生成する出力フォーマット |
| `EnablePageList` | — | `true` | EPUB page-list ナビゲーションを注入するか |
| `ChapterDirPattern` | — | `^\d{2}-` | チャプターフォルダを識別する正規表現パターン |
| `ChapterFilePattern` | — | `^\d{2}-.*\.md$` | チャプターファイルを識別する正規表現パターン |
| `CoverFile` | — | `00-COVER.md` | カバーとして扱う Markdown ファイル名 |
| `PreserveTemp` | — | `false` | ビルド後に一時ディレクトリを保持するか |
| `MetadataFile` | — | `.github/skills-config/ebook-build/amazon-kdp-guide.metadata.yaml` | メタデータ YAML ファイルのパス（上書き） |
| `StyleFile` | — | `assets/style.css` | EPUB スタイルシートのパス（上書き） |
| `ConfigFile` | — | — | JSON 設定ファイルのパス（指定時は他パラメータを上書き） |

---

## 🎨 カスタマイズ

### メタデータ（タイトル・著者・説明）

```text
.github/skills-config/ebook-build/amazon-kdp-guide.metadata.yaml
```

書籍タイトル・著者名・説明文・言語などを編集します。  
このファイルは Pandoc に直接渡される YAML 形式です。

### スタイル（フォント・余白・見出しデザイン）

```text
.github/skills/ebook-build/assets/style.css
```

EPUB に適用される CSS ファイルです。Kindle 互換性を維持しながら調整してください。

### 実行設定（出力フォーマット・パターン等）

```text
.github/skills-config/ebook-build/amazon-kdp-guide.build.json
```

```json
{
  "sourceRoot": ".",
  "outputDir": ".\\ebook-output",
  "projectName": "amazon-kdp-guide",
  "metadataFile": ".\\.github\\skills-config\\ebook-build\\amazon-kdp-guide.metadata.yaml",
  "styleFile": ".\\.github\\skills\\ebook-build\\assets\\style.css",
  "formats": ["epub", "azw3", "mobi"],
  "enablePageList": true,
  "chapterDirPattern": "^\\d{2}-",
  "chapterFilePattern": "^\\d{2}-.*\\.md$",
  "coverFile": "00-COVER.md"
}
```

---

## 📦 出力結果の確認

ビルド成功後、以下のファイルが生成されます：

```text
ebook-output/
├── amazon-kdp-guide.epub    ← EPUB 形式（汎用）
├── amazon-kdp-guide.azw3    ← AZW3 形式（Kindle 最適化）
└── amazon-kdp-guide.mobi    ← MOBI 形式（旧 Kindle 互換）
```

KDP へのアップロードには **AZW3** または **EPUB** を使用してください。

---

## 🔗 関連ファイル

| ファイル | 説明 |
|---|---|
| `SKILL.md` | Copilot 向けスキル定義（パラメータ仕様） |
| `docs/README.md` | 実行ガイド（詳細版） |
| `VALIDATION_CHECKLIST.md` | 検証チェックリスト |
| `docs/KINDLE-COMPATIBILITY-CHECKLIST.md` | Kindle 互換性チェック |
| `scripts/invoke-ebook-build.ps1` | ビルド実行スクリプト（エントリポイント） |

---

## ✅ まとめ

| 項目 | 内容 |
|---|---|
| スキル名 | `ebook-build` |
| 対応フォーマット | EPUB / AZW3 / MOBI |
| 実行方法 | PowerShell / GitHub Copilot Agent |
| 前提ツール | Pandoc + Calibre |
| 設定ファイル | `configs/amazon-kdp-guide.build.json` |
| 出力先 | `ebook-output/` |

次のステップ: 生成した AZW3 ファイルを [02-upload-publish.md](./02-upload-publish.md) に従って KDP へアップロードしてください。
