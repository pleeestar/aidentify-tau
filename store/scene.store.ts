import { create } from "zustand";
import { SceneKind, SurfaceSpec } from "@/domain/types";

export type TransitionDirection = "forward" | "backward";

// シーンとSurfaceSpecのマッピング
const sceneSurfaceMap: Record<SceneKind, SurfaceSpec> = {
  home: { kind: "gradientNoise" },
  select: { kind: "darkNoise" },
  edit: { kind: "darkNoise" },
  process: { kind: "darkNoise" },
  result: { kind: "darkNoise" },
};

interface SceneState {
  scene: SceneKind;
  setScene: (scene: SceneKind, direction?: TransitionDirection) => void;
  surfaceSpec: SurfaceSpec;
  setSurfaceSpec: (spec: SurfaceSpec) => void;
  transitionDirection: TransitionDirection;
}

export const useSceneStore = create<SceneState>((set) => ({
  scene: "home",
  setScene: (scene, direction = "forward") => {
    const surfaceSpec = sceneSurfaceMap[scene];
    set({ 
      scene, 
      transitionDirection: direction,
      surfaceSpec: surfaceSpec || { kind: "gradientNoise" }
    });
  },
  surfaceSpec: { kind: "gradientNoise" },
  setSurfaceSpec: (spec) => set({ surfaceSpec: spec }),
  transitionDirection: "forward",
}));
