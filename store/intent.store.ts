import { create } from "zustand";
import { Intent } from "@/domain/domain";

interface IntentState {
  intent: Intent;
  setIntent: (intent: Intent) => void;
}

export const useIntentStore = create<IntentState>((set) => ({
  intent: "pixelate", // 初期値はどこか一つ
  setIntent: (intent) => set({ intent }),
}));