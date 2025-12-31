"use client";
import { useSceneStore } from "@/store/scene.store";
import { HomeScene } from "@/scenes/Home.scene";
import { SelectScene } from "@/scenes/Select.scene";
import { EditScene } from "@/scenes/Edit.scene";
import { ProcessScene } from "@/scenes/Process.scene";
import { ResultScene } from "@/scenes/Result.scene";

export const SceneRenderer = () => {
  const scene = useSceneStore((s) => s.scene);
  
  // Strict matching based on SceneKind
  switch (scene) {
    case "home": return <HomeScene />;
    case "select": return <SelectScene />;
    case "edit": return <EditScene />;
    case "process": return <ProcessScene />;
    case "result": return <ResultScene />;
    default: return null;
  }
};
