import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { Card } from "@/components/primitives/Card";
import { Text } from "@/components/primitives/Text";

const ResultView = ({ vm }: { vm: ReturnType<typeof useSceneVM> }) => (
  <>
    {/* Overlay */}
    <div className="absolute inset-0 z-20 pointer-events-none flex flex-col justify-end">
        <div className="pointer-events-auto">
           <BottomSheet title="Analysis Result">
               <Card className="p-4 bg-zinc-800">
                  <Text>Privacy Risk: Low</Text>
               </Card>
           </BottomSheet>
        </div>
    </div>

    {/* Content */}
    <VStack className="h-full justify-center items-center p-4">
        <div className="w-full aspect-4/5 bg-zinc-800 rounded-lg" /> {/* Final Image */}
    </VStack>
  </>
);

export const ResultScene = createScene({
  header: { kind: "text", title: "Result", action: "exit" },
  viewModel: useSceneVM,
  view: ResultView,
});
