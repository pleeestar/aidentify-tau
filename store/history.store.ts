import { create } from "zustand";

interface HistoryState {
  riskScoreHistory: number[];
  addHistory: (score: number) => void;
}

export const useHistoryStore = create<HistoryState>((set) => ({
  riskScoreHistory: [],
  addHistory: (score) => set((state) => ({ riskScoreHistory: [...state.riskScoreHistory, score] })),
}));
