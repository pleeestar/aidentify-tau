import { create } from "zustand";
import { Intent } from "@/domain/types";

interface IntentState {
  selectedIntent: Intent | null;
  setIntent: (intent: Intent) => void;
}

export const useIntentStore = create<IntentState>((set) => ({
  selectedIntent: null,
  setIntent: (intent) => set({ selectedIntent: intent }),
}));
