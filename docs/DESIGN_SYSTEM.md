# Design System & Implementation

FigmaのデザインをどのようにReactコンポーネントへ変換したかを定義しています。

### 1. Design Tokens
- **Space**: 4px（Tailwind基準）。Figma上の余白を `gap-n` に正確にマッピング。
- **Colors**: 背景は `Zinc-950` を基調とし、透明度（`/10`, `/20`）を活用して奥行きを表現。

### 2. Figma to Component Mapping
| Figma Component | Code Component | Description |
| :--- | :--- | :--- |
| Auto Layout (Vertical) | `VStack.tsx` | 余白の一貫性を担保 |
| Icon Set | `Glyph.tsx` | Lucide Reactによる型安全なアイコン呼び出し |
| Scene Frame | `Surface.tsx` | 全画面共通の背景グラデーション |

### Figma Link
Figma: [デザインファイル](https://www.figma.com/design/7Mx1oGmjI7TZVhLMN0O1BC/Aidentify-UI?node-id=2018-314&t=BNiz9XHR42Qde2zH-1)



![フィグマァアアア](/assets/figma.png "figma")