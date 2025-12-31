import { create } from "zustand";
import { EditMode } from "@/domain/types";

interface EditState {
  mode: EditMode;
  setMode: (mode: EditMode) => void;
}

export const useEditStore = create<EditState>((set) => ({
  mode: "magic",
  setMode: (mode) => set({ mode }),
}));
