#!/bin/bash
set -e

echo "✨ Injecting Motion Strategy into aidentify architecture..."

# 1. Motion Definitions (The Grammar of Movement)
# -----------------------------------------------
# SwiftUIの .transition や .animation のようなプリセットを定義します
cat <<'EOF' > motion/variants.ts
import { Variants } from "framer-motion";

// 画面遷移の標準アニメーション
export const pageTransition: Variants = {
  initial: { opacity: 0, scale: 0.98, filter: "blur(10px)" },
  animate: { opacity: 1, scale: 1, filter: "blur(0px)" },
  exit: { opacity: 0, scale: 1.02, filter: "blur(10px)" },
};

// コンテナ内の要素を順番に出現させる (Stagger)
export const staggerContainer: Variants = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2,
    },
  },
};

// 下からふわっと浮き上がる要素
export const fadeInUp: Variants = {
  hidden: { opacity: 0, y: 20, filter: "blur(5px)" },
  show: { 
    opacity: 1, 
    y: 0, 
    filter: "blur(0px)",
    transition: { type: "spring", stiffness: 100, damping: 15 } 
  },
};

// ポップアップ系 (BottomSheetなど)
export const slideUp: Variants = {
  hidden: { y: "100%" },
  show: { y: 0, transition: { type: "spring", stiffness: 300, damping: 30 } },
  exit: { y: "100%" },
};
EOF

# 2. Update SceneRenderer (Global Transition Manager)
# ---------------------------------------------------
# AnimatePresence を導入し、Storeの状態変化をトリガーにします
cat <<'EOF' > components/SceneRenderer.tsx
"use client";
import { useSceneStore } from "@/store/scene.store";
import { HomeScene } from "@/scenes/Home.scene";
import { SelectScene } from "@/scenes/Select.scene";
import { EditScene } from "@/scenes/Edit.scene";
import { ProcessScene } from "@/scenes/Process.scene";
import { ResultScene } from "@/scenes/Result.scene";

import { AnimatePresence, motion } from "framer-motion";
import { pageTransition } from "@/motion/variants";

export const SceneRenderer = () => {
  const scene = useSceneStore((s) => s.scene);

  // Sceneのマッピング
  const getSceneComponent = () => {
    switch (scene) {
      case "home": return <HomeScene />;
      case "select": return <SelectScene />;
      case "edit": return <EditScene />;
      case "process": return <ProcessScene />;
      case "result": return <ResultScene />;
      default: return null;
    }
  };

  return (
    // mode="wait" で「前の画面が消えてから次の画面が出る」ようにする
    <AnimatePresence mode="wait">
      <motion.div
        key={scene} // これが重要：keyが変わるとReactは「別の要素」と認識してアニメーションする
        variants={pageTransition}
        initial="initial"
        animate="animate"
        exit="exit"
        transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }} // Apple-like ease
        className="w-full h-full"
      >
        {getSceneComponent()}
      </motion.div>
    </AnimatePresence>
  );
};
EOF

# 3. Update Home Scene (Micro-Interaction Example)
# ------------------------------------------------
# Traitsなどの要素にアニメーションを適用する例
cat <<'EOF' > scenes/Home.scene.tsx
import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { Badge } from "@/components/primitives/Badge";
import { Traits } from "@/components/primitives/Traits";
import { Sticker } from "@/components/primitives/Sticker";
import { Authorship } from "@/components/primitives/Authorship";
import { Button } from "@/components/assemblies/Button";
import { Glyph } from "@/components/primitives/Glyph";

// Motion
import { motion } from "framer-motion";
import { staggerContainer, fadeInUp } from "@/motion/variants";

const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between p-6">
    
    {/* Stagger Animation applied to the container */}
    <motion.div 
      variants={staggerContainer}
      initial="hidden"
      animate="show"
      className="flex-1 flex flex-col justify-center items-center gap-6"
    >
      <motion.div variants={fadeInUp}>
        <Badge label="v3.0" />
      </motion.div>
      
      <motion.div variants={fadeInUp}>
        <Traits active={true} />
      </motion.div>
      
      <motion.div variants={fadeInUp}>
        <Sticker />
      </motion.div>
    </motion.div>

    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.5 }}
      className="flex flex-col gap-4"
    >
      <Authorship />
      <Button onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" /> Start
      </Button>
    </motion.div>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
EOF

# 4. Update Process Scene (Continuous Animation Example)
# ----------------------------------------------------
# 処理中のアニメーション
cat <<'EOF' > scenes/Process.scene.tsx
import { createScene } from "./createScene";
import { useProcessVM } from "@/viewmodel/process.vm";
import { VStack } from "@/components/primitives/VStack";
import { Traits } from "@/components/primitives/Traits";
import { Text } from "@/components/primitives/Text";
import { Spinner } from "@/components/primitives/Spinner";
import { Authorship } from "@/components/primitives/Authorship";
import { motion } from "framer-motion";

const ProcessView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-center items-center" gap={8}>
      <motion.div 
        animate={{ scale: [1, 1.1, 1], opacity: [0.5, 1, 0.5] }} 
        transition={{ repeat: Infinity, duration: 2 }}
      >
        <Traits active={false} />
      </motion.div>

      <Text className="animate-pulse">AI is processing... {vm.progress}%</Text>
      
      <Spinner />
      
      <motion.div 
        initial={{ opacity: 0 }} 
        animate={{ opacity: 1 }} 
        transition={{ delay: 1 }}
      >
        <Authorship />
      </motion.div>
  </VStack>
);

export const ProcessScene = createScene({
  header: { kind: "none" },
  viewModel: useProcessVM,
  view: ProcessView,
});
EOF

echo "✅ Motion strategy applied."
echo "   - transitions defined in motion/variants.ts"
echo "   - SceneRenderer wrapped in AnimatePresence"
echo "   - HomeScene updated with staggered entrance"