// Discriminated Unions for State
export type SceneKind = "home" | "select" | "edit" | "process" | "result";
export type Intent = "mask" | "blur" | "pixelate" | "remove" | "auto";
export type EditMode = "crop" | "tune" | "magic";

export type HeaderSpec = 
  | { kind: "logo"; action?: string }
  | { kind: "text"; title: string; action?: string }
  | { kind: "none" };

export type SurfaceSpec = {
  kind: "gradientNoise" | "darkNoise";
};
