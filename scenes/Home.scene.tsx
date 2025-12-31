import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { Badge } from "@/components/primitives/Badge";
import { Traits } from "@/components/primitives/Traits";
import { Sticker } from "@/components/primitives/Sticker";
import { Authorship } from "@/components/primitives/Authorship";
import { Button } from "@/components/assemblies/Button";
import { Glyph } from "@/components/primitives/Glyph";

const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between p-6">
    <VStack className="flex-1 justify-center items-center">
      <Badge label="v3.0" />
      <Traits active={true} />
      <Sticker />
    </VStack>
    <VStack>
      <Authorship />
      <Button onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" /> Start
      </Button>
    </VStack>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
