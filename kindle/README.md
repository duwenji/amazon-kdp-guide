# 📖 Amazon KDP ガイド を Kindle 形式に変換

このフォルダには、**amazon-kdp-guide** マークダウン教材を **Kindle 互換形式（EPUB / AZW3 / MOBI）** に自動変換するための完全なツールセットが含まれています。

---

## 📋 フォルダ構成

```
kindle/
├── README.md                              ← このファイル（使い方ガイド）
├── convert-to-kindle.ps1                  ← 自動変換スクリプト（メインツール）
├── metadata.yaml                          ← 書籍メタデータ設定
├── style.css                              ← EPUB スタイルシート
├── KINDLE-COMPATIBILITY-CHECKLIST.md      ← 互換性チェックリスト
└── output/                                ← 変換済みファイル出力先（実行後に自動作成）
    ├── amazon-kdp-guide.epub              ← EPUB 3.0 形式
    ├── amazon-kdp-guide.azw3              ← Kindle デバイス対応
    └── amazon-kdp-guide.mobi              ← 旧式 Kindle デバイス対応
```

---

## 🎯 各ファイルの役割

### 1. **convert-to-kindle.ps1** - メイン自動変換スクリプト

**何をするのか:**
- すべてのマークダウン（`*.md`）ファイルを 1 つの統合された電子書籍に変換
- 自動的に目次（Table of Contents）を生成
- 複数の形式（EPUB → AZW3 → MOBI）に自動変換
- エラーハンドリングと詳細なログを表示

**依存ツール:**
- ✅ **Pandoc** 必須（Markdown→EPUB 変換用）
- ⚠️ **Calibre（ebook-convert）** オプション（EPUB→AZW3/MOBI 変換用）

**実行方法:**
```powershell
# PowerShell を開く
cd c:\dev\apps\amazon-kdp-guide\kindle

# 実行ポリシー確認（初回のみ）
Get-ExecutionPolicy

# 必要に応じて一時的に変更
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# スクリプト実行
.\convert-to-kindle.ps1
```

---

## 📦 必須ツール設定

### **Pandoc をインストール**

macOS (Homebrew):
```bash
brew install pandoc
```

Windows (Chocolatey):
```powershell
choco install pandoc
```

Windows (直接インストール):
https://pandoc.org/installing.html から Windows インストーラーをダウンロード

検証:
```powershell
pandoc --version
```

---

### **Calibre をインストール（オプション、AZW3 / MOBI 形式用）**

https://calibre-ebook.com/download からダウンロード

インストール後、PowerShell でテスト:
```powershell
ebook-convert --version
```

---

## 🚀 クイックスタート

### ステップ 1: ファイル構造を確認

親フォルダ（`amazon-kdp-guide/`）の構造が以下のようになっていることを確認:

```
amazon-kdp-guide/
├── 00-COVER.md                           ← カバー（オプション）
├── 01-basics-knowledge/
│   ├── 01-overview.md
│   └── 02-account-setup.md
├── 02-manuscript-and-publishing/
│   ├── 01-prepare-manuscript.md
│   └── 02-upload-publish.md
├── 03-advanced-topics/
│   ├── 01-metadata-and-pricing.md
│   └── 02-kindle-unlimited.md
├── README.md                             ← 自動更新される目次
└── kindle/
    └── convert-to-kindle.ps1
```

**重要:** フォルダ名は必ず `^\d{2}-` （例: `01-`, `02-`）で始まる必要があります。

---

### ステップ 2: スクリプト実行

```powershell
cd c:\dev\apps\amazon-kdp-guide\kindle
.\convert-to-kindle.ps1
```

スクリプトが自動的に以下を処理します：
- ✅ すべてのマークダウンファイルを発見
- ✅ 目次を生成
- ✅ メタデータを適用
- ✅ EPUB、AZW3、MOBI ファイルを生成
- ✅ `output/` フォルダに保存

---

### ステップ 3: 出力を確認

```
output/
├── amazon-kdp-guide.epub    ← 最初に確認するファイル
├── amazon-kdp-guide.azw3    ← Kindle デバイス用
└── amazon-kdp-guide.mobi    ← 旧式 Kindle 用
```

EPUB ファイルをブラウザまたは e-reader で開いて内容を確認します。

---

## ⚙️ カスタマイズ

### **書籍メタデータを変更**

`metadata.yaml` を編集します：

```yaml
title: ガイドのタイトル
subtitle: サブタイトル
author: あなたの名前
date: 2026-03-20
description: >
  書籍の説明text
```

### **スタイルを変更**

`style.css` を編集して、フォント、色、余白などをカスタマイズ可能です。

**注意:** Kindle 端末は CSS サポートが限定的なため、複雑なスタイルは避けてください。

---

## 🔍 トラブルシューティング

### Pandoc が見つからない
```
❌ エラー: Pandoc がインストールされていません
```

**解決策:**
```powershell
# Pandoc をインストール
choco install pandoc
# または https://pandoc.org/installing.html

# PowerShell を再起動
```

### ファイルが見つからない
```
❌ エラー: 変換対象の markdown ファイルが見つかりません
```

**確認事項:**
- [ ] フォルダ名が `^\d{2}-` で始まっているか（例: `01-basics-knowledge/`）
- [ ] 各フォルダ内のファイルドが `^\d{2}-` で始まっているか（例: `01-overview.md`）
- [ ] ファイルの拡張子が `.md` か

### AZW3/MOBI が生成されない
```
⚠️ ebook-convert が見つかりません
```

**解決策:**
- [ ] Calibre をインストール: https://calibre-ebook.com/download
- [ ] PowerShell を再起動
- [ ] EPUB ファイルは正常に生成されるため、AZW3 への変換はオプションです

---

## ✅ 互換性チェック

変換後、必ず **KINDLE-COMPATIBILITY-CHECKLIST.md** を参照して検証してください。

重要なチェック項目：
- [ ] 見出しレベルが正しい
- [ ] テーブルが正しく表示される
- [ ] コードブロックが完全に表示される
- [ ] 内部リンクが機能する
- [ ] 画像（あれば）が表示される

---

## 📚 参考資料

- **Pandoc 公式ドキュメント**: https://pandoc.org/
- **Calibre 公式サイト**: https://calibre-ebook.com/
- **Kindle フォーマット仕様**: https://amazon.com/gp/feature.html?ie=UTF8&docId=1000765261
- **EPUB 3.0 仕様**: https://www.w3.org/publishing/epub32/

---

## 🤝 サポート

問題が発生した場合は、以下を確認してください：
1. ファイル構造が正しいか
2. Pandoc が正常にインストールされているか
3. markdown ファイルの形式が正しいか（特に見出しレベル）
4. メタデータが有効な YAML 形式か
