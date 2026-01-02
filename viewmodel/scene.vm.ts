import { useSceneStore } from "@/store/scene.store";
export const useSceneVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  return {
    onLogin: () => setScene("select", "forward"),
    onExit: () => setScene("home", "backward"),
  };
};
