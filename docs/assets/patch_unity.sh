#!/bin/bash
set -e

echo "🛠 Refactoring to Page-Level Layout (Centralized Header/Surface)..."

# 1. Header を「状態監視型」に書き換え
cat <<'EOF' > components/layout/Header.tsx
"use client";
import { useSceneStore } from "@/store/scene.store";
import { HStack } from "@/components/primitives/HStack";
import { Text } from "@/components/primitives/Text";
import { Glyph } from "@/components/primitives/Glyph";
import { useSceneVM } from "@/viewmodel/scene.vm";

export const Header = () => {
  const scene = useSceneStore((s) => s.scene);
  const { onExit } = useSceneVM(); // 共通の終了ロジック

  // Sceneごとの設定を定義
  const specs: Record<string, { title?: string; kind: "logo" | "text" | "none"; action?: boolean }> = {
    home: { kind: "logo", action: false },
    select: { kind: "text", title: "Select", action: true },
    edit: { kind: "text", title: "Edit", action: true },
    process: { kind: "none" },
    result: { kind: "text", title: "Result", action: true },
  };

  const spec = specs[scene] || specs.home;

  if (spec.kind === "none") return <div className="h-20" />; // スペースだけ確保

  return (
    <header className="fixed top-0 w-full p-6 z-50">
      <HStack className="justify-between">
        {spec.kind === "logo" ? (
          <Text className="text-2xl font-bold italic">aidentify</Text>
        ) : (
          <Text className="text-2xl font-serif italic">{spec.title}</Text>
        )}
        
        {spec.action && (
          <button onClick={onExit} className="p-2 bg-white/10 rounded-full">
             <Glyph variant="Exit" className="w-5 h-5" />
          </button>
        )}
      </HStack>
    </header>
  );
};
EOF

# 2. createScene を「コンテンツのみ」に軽量化
cat <<'EOF' > scenes/createScene.tsx
import { ReactNode } from "react";

type AdapterConfig<VM> = {
  viewModel: () => VM;
  view: (props: { vm: VM }) => ReactNode;
};

export function createScene<VM>(config: AdapterConfig<VM>) {
  return function SceneAdapter() {
    const vm = config.viewModel();
    return <config.view vm={vm} />;
  };
}
EOF

# 3. page.tsx で Surface と Header を一元管理
cat <<'EOF' > app/page.tsx
import { Surface } from "@/components/layout/Surface";
import { Header } from "@/components/layout/Header";
import { SceneRenderer } from "@/components/SceneRenderer";

export default function Page() {
  return (
    <Surface>
      <Header />
      <main className="w-full h-full">
        <SceneRenderer />
      </main>
    </Surface>
  );
}
EOF

echo "✅ Refactor complete! Header and Surface are now persistent in page.tsx."