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
