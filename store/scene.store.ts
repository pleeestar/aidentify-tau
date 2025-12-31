import { create } from "zustand";
import { SceneKind } from "@/domain/types";

interface SceneState {
  scene: SceneKind;
  setScene: (scene: SceneKind) => void;
}

export const useSceneStore = create<SceneState>((set) => ({
  scene: "home",
  setScene: (scene) => set({ scene }),
}));
