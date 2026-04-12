# 03. ebook-build スキル — 電子書籍の自動ビルド

## 📖 このセクションで学べること

このセクションを読むと、以下が理解できます：

- ✅ `ebook-build` スキルの目的と仕組み
- ✅ 1 コマンドで EPUB / PDF / KDP 登録 Markdown を生成する方法
- ✅ 実行前の前提条件（Pandoc・Node.js・Chrome/Edge）の確認方法
- ✅ メタデータ・スタイル・出力先のカスタマイズ方法
- ✅ パラメータ一覧と各設定項目の意味

**学習時間**: 約 15 分

## この章の前提

- 利用側リポジトリ（consumer repo）: `amazon-kdp-guide`
  - GitHub: `https://github.com/duwenji/amazon-kdp-guide`
  - ローカル: `c:\dev\apps\amazon-kdp-guide`
  - 役割: 実行設定と実行用 wrapper を持つ利用側リポジトリ
- 共有リポジトリ（shared repo）: `shared-copilot-skills`
  - GitHub: `https://github.com/duwenji/shared-copilot-skills`
  - 役割: `ebook-build` の共有実装を提供する共有リポジトリ
- 実行用 wrapper（利用者向け入口）: `./.github/skills-config/ebook-build/invoke-build.ps1`

> 💡 `01-prepare-manuscript.md` では手動での変換手順を解説しています。  
> このセクションでは、同じ変換処理をスクリプト化した **ebook-build スキル** による自動化を紹介します。

---

## 🎯 ebook-build スキルとは

`ebook-build` は、Markdown で書かれた書籍をワンコマンドで **EPUB / PDF / KDP 登録 Markdown** に変換するための再利用可能なビルドフローです。

このリポジトリでは `.github/skills-config/ebook-build/` の **実行用 wrapper** から実行し、共有リポジトリ（shared repo）である `shared-copilot-skills/ebook-build` の実装へ委譲します。GitHub Copilot Agent モードからの利用にも、PowerShell からの直接実行にも対応しています。

> ⚠️ このスキルが自動化するのは **出版準備** までです。KDP 管理画面への最終アップロード、入力確認、公開申請は人が実施してください。

### できること

1. 番号付き Markdown チャプター構造（`01-`, `02-` ...）からコンテンツを収集
2. 専用の **メタデータ**・**スタイルシート** を適用して EPUB を生成
3. HTML + ローカル Chrome/Edge を使って固定レイアウト寄りの PDF を生成
4. `*.metadata.yaml` と `*.kdp.yaml` から KDP 登録用 Markdown を生成
5. 成果物を `ebook-output/` に出力

### スキルのファイル構成

利用側リポジトリ（consumer repo）で管理する設定と、共有リポジトリ（shared repo）の `ebook-build` 実装に分かれています。

```text
.github/
├── skills-config/
│   └── ebook-build/
│       ├── invoke-build.ps1                  ← 実行用 wrapper（利用者向け入口）
│       ├── amazon-kdp-guide.build.json       ← このリポジトリ用の実行設定
│       ├── amazon-kdp-guide.metadata.yaml    ← 書籍メタデータ
│       └── amazon-kdp-guide.kdp.yaml         ← KDP 登録補助メタデータ
└── skills/
    └── ebook-build/
        ├── SKILL.md                          ← Skill 定義（Copilot 向け）
        ├── EBOOK_BUILD_SPECIFICATION.md      ← 実装仕様
        ├── VALIDATION_CHECKLIST.md           ← 検証チェックリスト
        ├── assets/
        │   └── style.css                     ← EPUB スタイルシート
        ├── docs/
        │   ├── README.md                     ← 実行ガイド（詳細版）
        │   └── KINDLE-COMPATIBILITY-CHECKLIST.md
        └── scripts/
            ├── invoke-ebook-build.ps1        ← 共有実装
            ├── convert-to-kindle.ps1         ← 変換コア
            └── add-pagelist-functions.ps1    ← page-list 補助
```

---

## 🔧 前提条件

実行前に以下のツールがインストールされていることを確認してください。

### Pandoc

Markdown → EPUB / HTML 変換に使用します。

```powershell
pandoc --version
```

インストール: https://pandoc.org/installing.html

### Node.js

PDF 生成時の補助スクリプト実行に使用します。

```powershell
node -v
```

### Chrome または Edge

HTML を印刷用 PDF に変換するために使用します。ローカルにどちらか一方が入っていれば十分です。

### Shared Skill の取得（初回のみ）

共有 Skill をまだ取得していない場合は、以下を実行します。

```powershell
git submodule update --init --recursive
```

> 💡 EPUB のみを生成する場合は `Pandoc` が必須です。`PDF` も生成する場合は `Node.js` と `Chrome/Edge` も必要です。

---

## 🚀 実行方法

### 最短実行（推奨）

このリポジトリでは実行用 wrapper が既定の設定ファイルを読み込むため、以下の 1 コマンドで実行できます。

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills-config\ebook-build\invoke-build.ps1
```

### 別の設定ファイルを指定する場合

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills-config\ebook-build\invoke-build.ps1 `
  -ConfigFile .\.github\skills-config\ebook-build\amazon-kdp-guide.build.json
```

> 💡 `invoke-build.ps1` は実行用 wrapper（利用者向け入口）です。内部で共有実装 `invoke-ebook-build.ps1` を呼び出します。

---

## ⚙️ `.build.json` で調整できる主な設定項目

実行用 wrapper は `*.build.json` を読み込み、以下の設定値を共有実装に渡します。

| 設定項目 | 必須 | 既定値 | 説明 |
|---|---|---|---|
| `SourceRoot` | ✅ | — | チャプターフォルダを含むルートディレクトリ（またはそれ以下の docs/ ルート） |
| `OutputDir` | — | `<SourceRoot>/ebook-output` | 成果物の出力先フォルダ |
| `ProjectName` | — | `SourceRoot` のフォルダ名 | 出力ファイル名のベース（例: `amazon-kdp-guide`） |
| `Formats` | — | `["epub", "pdf", "kdp-markdown"]` | 生成する出力フォーマット |
| `KdpMetadataFile` | — | `.github/skills-config/ebook-build/amazon-kdp-guide.kdp.yaml` | KDP 登録補助 Markdown 用の追加メタデータ |
| `EnablePageList` | — | `true` | 旧互換設定。現在は主に EPUB / PDF / KDP 登録情報の出力を利用 |
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
../shared-copilot-skills/ebook-build/assets/style.css
```

EPUB に適用される CSS ファイルです。Kindle 互換性を維持しながら調整してください。

### 実行設定（出力フォーマット・パターン等）

```text
.github/skills-config/ebook-build/amazon-kdp-guide.build.json
```

```json
{
  "sourceRoot": "./docs",
  "outputDir": "./ebook-output",
  "projectName": "amazon-kdp-guide",
  "metadataFile": "./.github/skills-config/ebook-build/amazon-kdp-guide.metadata.yaml",
  "kdpMetadataFile": "./.github/skills-config/ebook-build/amazon-kdp-guide.kdp.yaml",
  "formats": ["epub", "pdf", "kdp-markdown"],
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
├── amazon-kdp-guide.epub                  ← KDP アップロード用の主要成果物
├── amazon-kdp-guide.pdf                   ← 固定レイアウト確認・配布用
└── amazon-kdp-guide-kdp-registration.md   ← KDP 登録情報の入力補助
```

KDP へのアップロードには通常 **EPUB** を使用し、`*-kdp-registration.md` を見ながらタイトル・説明文・カテゴリ・価格を入力してください。

---

## 🔗 関連ファイル

| ファイル | 説明 |
|---|---|
| `../shared-copilot-skills/ebook-build/SKILL.md` | Copilot 向けスキル定義（パラメータ仕様） |
| `../shared-copilot-skills/ebook-build/EBOOK_BUILD_SPECIFICATION.md` | 詳細な処理仕様 |
| `../shared-copilot-skills/ebook-build/VALIDATION_CHECKLIST.md` | 検証チェックリスト |
| `.github/skills-config/ebook-build/invoke-build.ps1` | 実行用 wrapper（利用者向け入口） |
| `../shared-copilot-skills/ebook-build/scripts/invoke-ebook-build.ps1` | wrapper から呼ばれる共有実装 |

---

## ✅ まとめ

| 項目 | 内容 |
|---|---|
| スキル名 | `ebook-build` |
| 対応成果物 | EPUB / PDF / KDP 登録 Markdown |
| 実行方法 | PowerShell / GitHub Copilot Agent |
| 前提ツール | Pandoc + Node.js + Chrome/Edge + 初回 `git submodule update --init --recursive` |
| 設定ファイル | `.github/skills-config/ebook-build/amazon-kdp-guide.build.json` |
| 出力先 | `ebook-output/` |

次のステップ: 生成した `amazon-kdp-guide.epub` と `amazon-kdp-guide-kdp-registration.md` を使って [02-upload-publish.md](./02-upload-publish.md) に従い KDP 登録を進めてください。
