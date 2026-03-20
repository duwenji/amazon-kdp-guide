# Ebook Build Usage Guide

このドキュメントは、amazon-kdp-guide の電子書籍変換フローを Skill として運用するための実行ガイドです。

---

## フォルダ構成

```text
.github/skills/ebook-build/
├── SKILL.md                                  ← Skill 定義
├── EBOOK_BUILD_SPECIFICATION.md              ← 実装仕様
├── VALIDATION_CHECKLIST.md                   ← 検証チェックリスト
├── configs/
│   ├── amazon-kdp-guide.build.json           ← amazon-kdp-guide 用実行設定
│   ├── amazon-kdp-guide.metadata.yaml        ← 書籍メタデータ
│   └── github-copilot-skills-tutorial.build.json
├── assets/
│   └── style.css                             ← EPUB スタイルシート
├── docs/
│   ├── README.md                             ← このファイル
│   └── KINDLE-COMPATIBILITY-CHECKLIST.md     ← Kindle 互換性チェック
└── scripts/
    ├── invoke-ebook-build.ps1                ← 実行エントリポイント
    ├── convert-to-kindle.ps1                 ← 変換コア
    └── add-pagelist-functions.ps1            ← page-list 補助

ebook-output/
├── amazon-kdp-guide.epub
├── amazon-kdp-guide.azw3
└── amazon-kdp-guide.mobi
```

---

## 実行方法

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills\ebook-build\scripts\invoke-ebook-build.ps1 `
  -ConfigFile .\.github\skills\ebook-build\configs\amazon-kdp-guide.build.json
```

---

## ビルド前提

- Pandoc が PATH にあること
- AZW3 / MOBI も生成する場合は Calibre の `ebook-convert` が PATH にあること

確認:

```powershell
pandoc --version
ebook-convert --version
```

---

## カスタマイズ

### メタデータ

編集対象:

```text
.github/skills/ebook-build/configs/amazon-kdp-guide.metadata.yaml
```

### スタイル

編集対象:

```text
.github/skills/ebook-build/assets/style.css
```

### 出力先

編集対象:

```text
.github/skills/ebook-build/configs/amazon-kdp-guide.build.json
```

既定の出力先:

```text
ebook-output/
```

---

## 出力確認

生成後に確認する主な成果物:

- `ebook-output/amazon-kdp-guide.epub`
- `ebook-output/amazon-kdp-guide.azw3`
- `ebook-output/amazon-kdp-guide.mobi`

---

## 検証

変換後は以下を確認します。

- `./KINDLE-COMPATIBILITY-CHECKLIST.md`
- `../VALIDATION_CHECKLIST.md`

特に以下を確認してください。

- 目次が正しい
- 内部リンクが機能する
- 見出し階層が崩れていない
- コードブロックが正しく表示される

---

## トラブルシューティング

### Pandoc が見つからない

- Pandoc をインストール
- PowerShell を再起動

### ebook-convert が見つからない

- Calibre をインストール
- PowerShell を再起動

### markdown が検出されない

- 章フォルダ名が `^\d{2}-` に一致しているか
- ファイル名が `^\d{2}-.*\.md$` に一致しているか
