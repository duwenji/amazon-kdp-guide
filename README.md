# 📚 Amazon KDP 完全ガイド

Amazon Kindle Direct Publishing（KDP）で電子書籍を出版・販売するための **完全マニュアル**です。アカウント作成から販売開始まで、すべての手順を詳しく解説します。

---

## 📖 このガイドについて

### 対象者
- ✅ 初めて電子書籍を出版する人
- ✅ clean-architecture を Kindle で販売したい人
- ✅ Amazon KDP で Kindle Unlimited に参加したい人
- ✅ 複数の書籍を効率的に出版したい人

### 学習内容
- 📍 Amazon KDP の仕組みと特徴
- 📍 アカウント作成・設定手順
- 📍 原稿準備（AZW3 ファイル生成）
- 📍 メタデータ・価格設定
- 📍 出版手順と審査プロセス
- 📍 Kindle Unlimited（読放題プログラム）
- 📍 マーケティングと販売促進
- 📍 よくあるトラブルと解決策

### 学習時間
**合計 3～4 時間**で、出版準備から公開まで完了可能です。

---

## 📚 ガイド構成

<!-- AUTO-TOC:START -->
- [00. Cover](./00-COVER.md)
- [01. Basics Knowledge](./01-basics-knowledge/)
  - [01. Overview](./01-basics-knowledge/01-overview.md)
  - [02. Account Setup](./01-basics-knowledge/02-account-setup.md)
- [02. Manuscript and Publishing](./02-manuscript-and-publishing/)
  - [01. Prepare Manuscript](./02-manuscript-and-publishing/01-prepare-manuscript.md)
  - [02. Upload Publish](./02-manuscript-and-publishing/02-upload-publish.md)
    - [03. Ebook Build Skill](./02-manuscript-and-publishing/03-ebook-build-skill.md)
- [03. Advanced Topics](./03-advanced-topics/)
  - [01. Metadata and Pricing](./03-advanced-topics/01-metadata-and-pricing.md)
  - [02. Kindle Unlimited](./03-advanced-topics/02-kindle-unlimited.md)
<!-- AUTO-TOC:END -->

---

## 🎯 学習ロードマップ

### **初心者向け（全て読むことをお勧め）**
```
① 01-overview.md（KDP 概要）
  ↓
② 02-account-setup.md（アカウント作成）
  ↓
③ 03-prepare-manuscript.md（原稿準備）
  ↓
④ 04-upload-publish.md（出版）
  ↓
⑤ 参考資料: 03-advanced-topics/01-metadata-and-pricing.md
  ↓
✅ 販売開始！
```

### **急ぎの方（重要なセクションのみ）**
```
① 01-overview.md（KDP 概要）
  ↓
③ 03-prepare-manuscript.md（原稿準備）
  ↓
④ 04-upload-publish.md（出版）
  ↓
✅ 販売開始！
```

### **Kindle Unlimited に参加したい方**
```
上記のロードマップ + 03-advanced-topics/02-kindle-unlimited.md
```

---

## 🚀 クイックスタート（10 分）

## 🛠 電子書籍ビルド Skill

このリポジトリでは、電子書籍生成フローを Skill として共通化しています。

入口ファイル:
- `./.github/skills/ebook-build/SKILL.md`
- `./.github/skills/ebook-build/docs/README.md`
- `./.github/skills/ebook-build/scripts/invoke-ebook-build.ps1`

最短実行:

```powershell
cd c:\dev\apps\amazon-kdp-guide
.\.github\skills\ebook-build\scripts\invoke-ebook-build.ps1 `
  -ConfigFile .\.github\skills-config\ebook-build\amazon-kdp-guide.build.json
```

出力先:
- `./ebook-output/`

submodule 運用コマンド:

```powershell
# 初回 clone 後
git submodule update --init --recursive

# 共有 Skill の更新取り込み
git submodule update --remote --merge .github/skills
```

共有 Skill リポジトリ:
- https://github.com/duwenji/shared-copilot-skills

## 🧩 Shared Skill 統一導線（Quiz + Ebook）

このリポジトリでは `shared-copilot-skills` を共通ソースとして利用します。

- Quiz validation wrapper: `./.github/skills-config/quiz-generator/invoke-validate.ps1`
- Quiz config: `./.github/skills-config/quiz-generator/quiz-generator.config.json`
- Ebook build wrapper: `./.github/skills-config/ebook-build/invoke-build.ps1`

実行例:

```powershell
cd c:\dev\apps\amazon-kdp-guide

# Quiz metadata / question validation
.\.github\skills-config\quiz-generator\invoke-validate.ps1 -Mode all

# Ebook build
.\.github\skills-config\ebook-build\invoke-build.ps1
```

shared skill の探索順:
1. `./.github/skills/shared-copilot-skills/*`
2. `./.github/skills/*`
3. `../shared-copilot-skills/*`

### **clean-architecture を Amazon KDP で販売する最短フロー**

```
ステップ 1️⃣: 原稿を準備
  → c:\dev\apps\clean-architecture で ebook-build を実行
  → .github\skills\ebook-build\scripts\invoke-ebook-build.ps1 を利用
  → ebook-output/clean-architecture.azw3 を取得
  
ステップ 2️⃣: AWS アカウント作成
  → https://account.amazon.com/
  
ステップ 3️⃣: KDP にサインアップ
  → https://kdp.amazon.com
  → 出版者情報を入力
  
ステップ 4️⃣: 新規タイトルを作成
  → 「新規タイトルを作成」をクリック
  
ステップ 5️⃣: メタデータを入力
  - タイトル: クリーンアーキテクチャ完全ガイド
  - 著者: 杜 文吉
  - 説明: 250 文字以内
  - カテゴリ: コンピュータ・テクノロジー
  - キーワード: 最大 7 個
  
ステップ 6️⃣: AZW3 をアップロード
  → clean-architecture.azw3
  
ステップ 7️⃣: 価格を設定
  → ¥980～¥9,999 の間で選択
  
ステップ 8️⃣: プレビューで確認
  → Kindle プレビューツールで表示確認
  
ステップ 9️⃣: 出版
  → 「出版」ボタンをクリック
  
✅ 24 時間以内に Amazon Kindle ストアで販売開始！
```

---

## 💡 Amazon KDP の 10 大特徴

| # | 特徴 | 説明 |
|----|------|------|
| 1️⃣ | **完全無料** | 登録・アップロード・出版すべて無料 |
| 2️⃣ | **高い印税率** | 70% まで獲得（出版社経由より高い） |
| 3️⃣ | **即座に販売開始** | 審査なし、数時間～24 時間で販売可 |
| 4️⃣ | **世界規模** | 170+ の国と地域で販売 |
| 5️⃣ | **自動 ISBN** | ISBN 購入不要（Amazon が自動割り当て） |
| 6️⃣ | **Kindle Unlimited** | 読放題プログラムで追加収入 |
| 7️⃣ | **POD 対応** | 紙の本も同じプラットフォームで販売可 |
| 8️⃣ | **いつでも修正** | ファイル・説明文をいつでも更新可 |
| 9️⃣ | **詳細な分析** | 売上・閲覧数を詳しく追跡 |
| 🔟 | **多言語対応** | 複数言語で同時出版可 |

---

## 📊 よくある 3 つの販売モデル

### **モデル A：通常販売のみ**
```
KDP で価格設定（例: ¥980）
  ↓
読者が購入
  ↓
あなたが 70% 獲得（¥686）
  ↓
Amazon が 30% 獲得

特徴: 単純、自由度高い
得意な場合: 専門書、技術書
```

### **モデル B：Kindle Unlimited 対応**
```
KDP の「Kindle Unlimited」に登録
  ↓
読者から 2 つの収入方法:
  1) 購入（通常販売）
  2) 読放題（ページ単価で報酬）
  ↓
月間プール（$40M+）から配分
  ↓
あなたの報酬 = 読まれたページ数で決定

特徴: 追加収入、読放題ユーザーにリーチ
得意な場合: ストーリー性がある書籍
注意: 他のプラットフォーム販売禁止
```

### **モデル C：紙 + Kindle 同時販売**
```
Amazon KDP + POD（Print on Demand）
  ↓
紙の本として注文を受け取る
  ↓
Amazon が自動で印刷・配送
  ↓
あなたが利益を獲得
  ↓
同時に Kindle 版を販売

特徴: リーチ最大化、高い信頼度
得意な場合: 実績を作りたい場合
```

---

## 🔑 成功のための 5 つのポイント

### 1️⃣ **高品質な原稿**
```
✅ 誤字・脱字なし
✅ 見出し・章立てが明確
✅ テーブル・コードが正しく表示される
✅ 画像が適正サイズ
```

### 2️⃣ **魅力的なメタデータ**
```
✅ 説明文：最初の 3 行で読者を魅了
✅ キーワード：検索で見つけやすく
✅ カテゴリ：正確に・詳しく
```

### 3️⃣ **価格戦略**
```
✅ 競合他社と比較
✅ 初期は低めに設定（レビュー獲得）
✅ 定期的にセール実施
```

### 4️⃣ **マーケティング**
```
✅ SNS で宣伝
✅ ブログで紹介
✅ 1 冊目は無料化・セール活用
```

### 5️⃣ **定期的な更新**
```
✅ レビューを読んで改善
✅ 誤字修正で版を更新
✅ 内容を追加
```

---

## 📱 このガイドと clean-architecture の連携

### **使用可能なツール**

```
c:\dev\apps\clean-architecture\
  ├── .github\skills\ebook-build\scripts\invoke-ebook-build.ps1
  ├── .github\skills-config\ebook-build\clean-architecture.build.json
  ├── .github\skills-config\ebook-build\clean-architecture.metadata.yaml
  ├── .github\skills\ebook-build\assets\style.css
  └── ebook-output\clean-architecture.azw3  ← KDP で使用

このガイド:
  amazon-kdp-guide/
  ├── README.md                ← このファイル
  ├── 01-overview.md           ← KDP 概要
  ├── 02-account-setup.md      ← アカウント作成
  ├── 03-prepare-manuscript.md ← AZW3 準備（連携）
  ├── 04-upload-publish.md     ← 出版手順
  └── ...其他
```

### **ワークフロー**

```
1. c:\dev\apps\clean-architecture\.github\skills\ebook-build\docs\README.md で設定確認
   ↓
2. invoke-ebook-build.ps1 で AZW3 を生成
   ↓
3. このガイドで出版方法を学習
   ↓
4. 03-prepare-manuscript.md で AZW3 をチェック
   ↓
5. 04-upload-publish.md に従って KDP にアップロード
   ↓
6. 出版！
```

---

## 🎯 各セクションの学習目標

### **01-overview.md を読んだ後**
- [ ] Amazon KDP とは何かが理解できた
- [ ] メリット・デメリットが説明できる
- [ ] 自分の用途に適しているか判断できた

### **02-account-setup.md を読んだ後**
- [ ] AWS / KDP アカウントの作成方法がわかった
- [ ] 支払い情報の設定ができた
- [ ] 著者プロフィールを完成させた

### **03-prepare-manuscript.md を読んだ後**
- [ ] AZW3 ファイルを正しく生成できた
- [ ] Kindle で表示確認ができた
- [ ] 原稿の問題点を特定・修正できた

### **04-upload-publish.md を読んだ後**
- [ ] KDP へのアップロード方法がわかった
- [ ] メタデータ入力ができた
- [ ] ファイルを公開できた

### **03-advanced-topics/01-metadata-and-pricing.md を読んだ後**
- [ ] 効果的なキーワード選択ができた
- [ ] 適切な価格を設定できた
- [ ] SEO を考慮した説明文が書ける

### **03-advanced-topics/02-kindle-unlimited.md を読んだ後**
- [ ] Kindle Unlimited の仕組みが理解できた
- [ ] 参加すべきか判断できた
- [ ] 読放題での収入を計算できた

---

## 💰 予想される収入

### **シナリオ別予測**

| シナリオ | 定価 | 月間販売数 | 月間収入 | 年間収入 |
|--------|------|---------|--------|---------|
| **趣味・副業（開始時）** | ¥980 | 10 冊 | ¥6,860 | ¥82,320 |
| **本格展開** | ¥1,980 | 100 冊 | ¥137,200 | ¥1,646,400 |
| **ベストセラー** | ¥2,980 | 500 冊 | ¥2,086,000 | ¥25,032,000 |

**注：** これらは推定値です。実際の売上は書籍の内容・マーケティング次第です。

---

## 🔗 外部リソース

### **公式サイト**
- Amazon KDP：https://kdp.amazon.com
- KDP ヘルプセンター：https://kdp.amazon.com/help
- Kindle ストア：https://amazon.co.jp/

### **便利なツール**
- Kindle プレビューツール：KDP ダッシュボードから無料利用
- KDP 用 CSS 検証ツール：https://www.amazon.com/kdp-css-validator
- 書籍表紙デザイン：Canva（https://www.canva.com）

### **参考情報**
- Kindle 形式仕様：https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf
- EPUB 仕様：https://www.w3.org/publishing/epub32/
- Amazon KDP コミュニティ：https://kdp.amazon.com/en_US/community

---

## 📞 よくある最初の質問

**Q：本当に無料で始められる？**

A：はい。登録も、ファイルアップロードも、販売も、すべて完全無料です。あなたが売上から 35～70% を獲得します。

---

**Q：どのくらい時間がかかる？**

A：
- アカウント作成：10 分
- 原稿準備（既存ファイルから）：30 分
- メタデータ入力：15 分
- 出版待機：24 時間

合計：数日で販売開始可能。

---

**Q：Kindle Unlimited に参加すべき？**

A：迷っているなら、まず非参加で始めることをお勧めします。理由：
- 他のプラットフォーム販売の自由度
- 収入パターンの多様性
- 後からいつでも参加・解除可能

---

**Q：修正できる？**

A：はい。いつでも修正・更新できます：
1. KDP ダッシュボードで「本を編集」
2. ファイルを差し替え
3. 「出版」をクリック
4. 数時間で反映

---

## 📝 次のステップ

### **今すぐ始める場合**
```
1. 01-overview.md を読む（20 分）
2. 02-account-setup.md を実行（15 分）
3. 03-prepare-manuscript.md で AZW3 を準備（30 分）
4. 04-upload-publish.md に従って出版（30 分）
→ 合計 95 分で販売開始！
```

### **じっくり学びたい場合**
```
1. 全 8 セクションを順番に読む（3～4 時間）
2. 各セクションの演習を実施
3. メモを取りながら学習
4. わからない部分は 08-FAQ で確認
5. 自信を持って出版開始
```

---

## 🎓 このガイドの活用方法

### **初回利用時**
- 全セクションを一通り読む
- 特に 02 と 04 は実際に手を動かしながら
- わからない部分はメモ

### **出版後**
- 販売成績に応じて 05・06・07 を参考に最適化
- 08 でトラブル対応
- 定期的に確認

### **複数冊目の出版時**
- 03～04 をサッと確認
- 前回との違いをメモ
- より効率的に出版

---

## 🚀 最後に

**Amazon KDP は、誰でも 1 日で本を出版できる最高のプラットフォームです。**

このガイドに従えば、あなたも：
- ✅ 電子書籍の著者になれる
- ✅ 世界中の読者に届けられる
- ✅ 継続的な収入を得られる

**さあ、始めましょう！** 📚✨

---

**最後の確認事項:**
- [ ] c:\dev\apps\clean-architecture\.github\skills\ebook-build\docs\README.md を確認した
- [ ] AZW3 ファイル生成方法を理解した
- [ ] このガイドの概要を読んだ
- [ ] 01-overview.md を読む準備がある

**準備完了したら、01-overview.md へ → →**

---

**ガイド更新日**: 2026-03-20  
**バージョン**: 1.0  
**対応形式**: EPUB, AZW3, MOBI  
**言語**: 日本語

**Happy Publishing! 🎉**
