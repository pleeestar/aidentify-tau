
# aidentify フロントエンド設計仕様書

**— SwiftUI的思想を Next.js / React に移植するための構造指針 —**

---

## 0. 本仕様書の目的

本仕様書は、画像プライバシー保護アプリ **aidentify** のフロントエンド実装において、

* UI を「意味」ではなく「構造」で扱うこと
* 状態・振る舞い・見た目を厳密に分離すること
* SwiftUI 的な宣言性・変更耐性を Web 技術で再現すること

を目的とする。

これは「Reactアプリの作り方」ではない。
**UI を一種の型付き言語として設計するための指南書**である。

---

## 1. 全体設計思想（最重要）

### 1.1 基本原則

本アプリは以下を絶対原則とする。

* **UI = 純粋関数に近づける**
* **状態は意味論（ViewModel）に集約する**
* **見た目の部品は意味を持たない**
* **命名は役割ではなく構造を示す**
* **状態遷移は discriminated union で閉じる**

React / Next.js はあくまで実装媒体であり、
**設計思想の起点ではない**。

---

## 2. レイヤード構造の定義

アプリケーションは以下のレイヤーに分割される。

```
App
 ├─ primitives        // 見た目の原子
 ├─ assemblies        // 状態を持つUI部品
 ├─ layout            // 全体構造
 ├─ scenes (adapter)  // View と State を接続
 ├─ viewmodel         // 状態の意味論
 ├─ store             // 状態の保存
 ├─ motion            // アニメーション抽象
 ├─ domain            // 型と制約
 └─ infra             // 通信・永続化
```

依存関係は **常に上位 → 下位のみ**。
逆依存は禁止。

---

## 3. View Primitive Layer（primitives）

### 3.1 役割

`primitives` は **純粋な見た目の記号**である。

* 状態を持たない
* 意味を解釈しない
* イベントを発火しない

### 3.2 設計ルール

* hooks 使用禁止
* zustand 参照禁止
* ドメイン型 import 禁止
* props は見た目に関係するもののみ

### 3.3 代表例

```tsx
<VStack as="Stage">
  <Text>...</Text>
</VStack>
```

`as` は **意味ではなく空間名**。
CSS や motion、デバッグのためのラベルであり、
ロジックに影響してはならない。

---

## 4. Dynamic Assembly Layer（assemblies）

### 4.1 役割

`assemblies` は primitives を組み合わせた **状態を持つUI構成要素**。

* UIState / FormState のみを持つ
* DomainState を解釈しない
* 単体で意味を完結させない

### 4.2 設計ルール

* hooks 使用可（UI系のみ）
* Intent / Mode の判断は禁止
* 「選択されているか？」は props で受け取る

### 4.3 例

* `Button`
* `BottomSheet`
* `ModeCarouselService`
* `IntentService`

> ❌「この Intent が選ばれたら遷移する」
>
> ✅「選ばれた Intent を表示する」

---

## 5. Layout Layer

### 5.1 役割

アプリ全体の **不変構造**を定義する。

* Header（title + action）
* Surface（背景・グラデーション）

### 5.2 HeaderSpec

Header は Scene から **仕様（Spec）として渡される**。

```ts
{
  kind: "text" | "logo" | "none"
  title?: string
  action?: "login" | "exit" | "cancel"
}
```

Header 自身は遷移ロジックを持たない。

---

## 6. Scene Adapter Layer（最重要）

### 6.1 Scene = 関手

Scene は View と State を接続する **Adapter（関手）**。

* hooks を束ねる
* state を props に射影する
* JSX に意味を流し込まない

### 6.2 Adapter の責務

* State の取得
* DerivedState の計算
* UI に渡す props の整形
* Intent 発火関数の生成

### 6.3 Adapter の禁止事項

* JSX を書く
* CSS / motion を直接扱う
* zustand を直接 mutate する

---

## 7. State / Hooks 分類

### 7.1 State 種別

| 種別           | 内容             |
| ------------ | -------------- |
| SceneState   | 現在の画面          |
| UIState      | 開閉・hover・focus |
| FormState    | 入力途中           |
| DomainState  | Intent / Mode  |
| ServerState  | AI処理           |
| DerivedState | 計算結果           |

### 7.2 原則

* primitives：State禁止
* assemblies：UI / Form のみ
* scenes(adapter)：全State可
* viewmodel：意味論のみ

---

## 8. ViewModel Layer

### 8.1 役割

ViewModel は **状態の意味論を定義する層**。

* Scene 遷移規則
* Intent 選択ルール
* Edit 操作の制約
* Process の進行状態

### 8.2 特徴

* UI を知らない
* React を知らない
* 純粋関数 + discriminated union

---

## 9. Domain Layer（型による安全性）

### 9.1 discriminated union の徹底

```ts
type Scene =
  | { kind: "Home" }
  | { kind: "Select" }
  | { kind: "Edit"; intent: Intent }
  | { kind: "Process" }
  | { kind: "Result"; score: Risk }
```

* 不正な状態は **型で表現不能**
* if 文ではなく switch で分岐
* 状態遷移は常に明示的

---

## 10. Motion Layer

### 10.1 役割

アニメーションを **意味から切り離す**。

* appear
* slide
* morph
* overlay

motion は

* adapter に直接書かれない
* state を直接読まない

View の構造に対する「演算」として扱う。

---

## 11. Infra Layer

### 11.1 AI 通信

* `ai.client.ts`：本番
* `ai.mock.ts`：ダミー

### 11.2 原則

* Adapter は client / mock を知らない
* ViewModel 経由でのみ使用
* ServerState として管理

---

## 12. テスト方針

* ViewModel：純関数テスト
* Adapter：state → props のスナップショット
* infra：mock 差し替え

UI テストは最小限。

## プロジェクトを始めるときに
Bootstrapスクリプトを使いましょう
雛形を作ってくれます



```
システム{

/* ===============================
 *  View Primitive Layer
 *  純粋な見た目の記号群
 *  意味・状態・振る舞いを一切持たない
 * =============================== */

primitives
 ├─ HStack.tsx          // 横配置
 ├─ VStack.tsx          // 縦配置
 ├─ ZStack.tsx          // 重ね合わせ
 ├─ Space.tsx           // 余白
 ├─ Frame.tsx           // 矩形・背景・角丸
 ├─ Text.tsx            // テキスト
 ├─ TitleLogo.tsx       // aidentifyロゴ
 ├─ Authorship.tsx      // ロゴ・作者表示
 ├─ Sticker.tsx         // ステッカーロゴ
 ├─ Glyph.tsx           // Play/Exit/FullscreenExit/Magic/Feather/ 等（variant）
 ├─ Badge.tsx           // 小情報表示
 ├─ Traits.tsx          // 特徴表示
 ├─ Spinner.tsx         // ローディング
 ├─ Tooltip.tsx         // 補助表示
 └─ Card.tsx            // 枠付き情報ブロック


/* ===========================================
 *  Dynamic Assembly Layer
 *  状態を持つUI構成要素
 *  primitives を組み合わせる / 独自CSS.divを持つ
 * =========================================== */

assemblies
 ├─ Button.tsx          // ボタン
 ├─ BottomSheet.tsx     // BottomSheet
 ├─ ModeCarouselService.tsx // モード選択のカルーセルUI/ドロップダウンの選択UI
 ├─ Slider.tsx          // Slider
 ├─ CropOverlay.tsx     // 範囲指定画像Overlay
 └─ IntentService.tsx   // Intentを選択/選択されているIntentを表示


/* ===============================
 *  Layout Layer
 *  アプリ全体の共通構造
 * =============================== */

layout
 ├─ Header.tsx          // 上部構造（title + action）
 └─ Surface.tsx         // 背景・グラデーション


/* ===============================
 *  Scene Adapter Layer
 *  View と State を接続する関手
 * =============================== */

scenes
 ├─ Home.scene.tsx{zustand = (kind="logo", action="login")}
 │   └─ Content
 │       └─ VStack
 │           ├─ VStack
 │           │   ├─ Badge
 │           │   ├─ Traits(animate)
 │           │   └─ Sticker
 │           └─ VStack
 │               ├─ Authorship
 │               └─ Button
 │                   └─ Glyph.Upload
 │
 ├─ Select.scene.tsx{zustand = (kind="text", title="Select", action="exit")}
 │   ├─ Overlay
 │   │   └─ BottomSheet[title=Intent, subtitle=12 Intents]
 │   │       └─ VStack
 │   │           ├─ Tooltip(intent)
 │   │           └─ IntentService(intent)
 │   └─ Content
 │       └─ VStack
 │           └─ ModeCarouselService(mode)
 │
 ├─ Edit.scene.tsx{zustand = (kind="text", title="Edit", action="exit")}  
 │   └─ Content
 │       └─ VStack
 │          ├─ Spacer
 │          ├─ VStack
 │          │   ├─ Text - 操作の説明
 │          │   ├─ ZStack as Stage
 │          │   │   ├─ CropOverlay
 │          │   │   └─ Image
 │          │   └─ HStack as Control
 │          │       ├─ IntentService(refer)
 │          │       ├─ DropdModeCarouselService(referDropdown)
 │          │       └─ Button
 │          │           └─ FullscreenExit
 │          └─ HStack as Action
 │              ├─ Slider
 │              └─ Button
 │                 └─ Glyph.Play
 │
 ├─ Process.scene.tsx{zustand = (kind="none"), action="cancel"}
 │   └─ Content
 │       └─ VStack
 │           ├─ Traits(stop)
 │           ├─ Text(progress) - AIが今どんな処理をしているか
 │           ├─ Spinner(animate)
 │           └─ Authorship
 │
 └─ Result.scene.tsx
     ├─ HeaderSpec(kind="text", title="Result", action="exit")
     ├─ Overlay
     │   └─ Sheet
     │       └─ Card(result)
     └─ Content
         └─ VStack
             └─ Image(final)


/* ===============================
 *  ViewModel Layer
 *  状態の意味論を定義
 * =============================== */

viewmodel
 ├─ scene.vm.ts        // Scene遷移
 ├─ intent.vm.ts       // Intent選択
 ├─ edit.vm.ts         // Edit操作
 └─ process.vm.ts      // AI処理状態


/* ===============================
 *  State Store
 * =============================== */

store
 ├─ scene.store.ts     // 現在のScene
 ├─ intent.store.ts    // Intent
 ├─ edit.store.ts      // Mode / Param
 └─ history.store.ts   // 危険度履歴


/* ===============================
 *  Motion Layer
 *  アニメーションの抽象化
 * =============================== */

motion
 ├─ appear.ts
 ├─ slide.ts
 ├─ morph.ts
 └─ overlay.ts


/* ===============================
 *  Domain / Infrastructure
 * =============================== */

domain
 ├─ intent.ts          // Intent型
 ├─ mode.ts            // EditMode型
 └─ scene.ts           // Scene discriminated union

infra
 ├─ ai.client.ts       // AI通信
 ├─ ai.mock.ts         // ダミー実装
 └─ storage.ts         // 永続化


/* ===============================
 *  App Root
 * =============================== */

app/page.tsx
 ├─ Layout(Surface + Header)
 ├─ SceneRenderer
 └─ Providers(store / motion)

}
```