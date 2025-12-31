import { create } from "zustand";
import { SceneKind } from "@/domain/types";
export const useAppStore = create<{ scene: SceneKind; setScene: (s: SceneKind) => void }>((set) => ({
  scene: "home", setScene: (scene) => set({ scene }),
}));
