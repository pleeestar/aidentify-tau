import { useSceneStore } from "@/store/scene.store";
import { useIntentStore } from "@/store/intent.store";
export const useIntentVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  const setIntent = useIntentStore((s) => s.setIntent);
  return {
    onSelectIntent: (i: any) => { setIntent(i); setScene("edit"); },
    onExit: () => setScene("home"),
  };
};
