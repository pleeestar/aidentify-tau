"use client";
import { useSceneStore } from "@/store/scene.store";
import { HomeScene } from "@/scenes/Home.scene";
import { SelectScene } from "@/scenes/Select.scene";
import { EditScene } from "@/scenes/Edit.scene";
import { ProcessScene } from "@/scenes/Process.scene";
import { ResultScene } from "@/scenes/Result.scene";

import { AnimatePresence, motion } from "framer-motion";
import { pageTransitionForward, pageTransitionBackward } from "@/motion/variants";

export const SceneRenderer = () => {
  const scene = useSceneStore((s) => s.scene);
  const transitionDirection = useSceneStore((s) => s.transitionDirection);

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

  // 遷移方向に応じてアニメーションを選択
  const variants = transitionDirection === "backward" 
    ? pageTransitionBackward 
    : pageTransitionForward;

  return (
    <div className="relative w-full h-full overflow-hidden">
      {/* mode="wait" で「前の画面が消えてから次の画面が出る」ようにする */}
      <AnimatePresence mode="wait">
        <motion.div
          key={scene} // これが重要：keyが変わるとReactは「別の要素」と認識してアニメーションする
          variants={variants}
          initial="initial"
          animate="animate"
          exit="exit"
          className="absolute inset-0 w-full h-full"
        >
          {getSceneComponent()}
        </motion.div>
      </AnimatePresence>
    </div>
  );
};
