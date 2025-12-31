import { useSceneStore } from "@/store/scene.store";
export const useEditVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  return {
    onPlay: () => setScene("process"),
    onExit: () => setScene("select"),
  };
};
