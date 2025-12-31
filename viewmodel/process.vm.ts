import { useSceneStore } from "@/store/scene.store";
import { useEffect, useState } from "react";

export const useProcessVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const timer = setTimeout(() => setScene("result"), 2000);
    return () => clearTimeout(timer);
  }, [setScene]);

  return {
    progress,
    onCancel: () => setScene("edit"),
  };
};
