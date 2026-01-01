import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack, Badge, Traits, Sticker, Authorship, Glyph, Text } from "@/components/primitives/";
import { Button } from "@/components/assemblies/";

const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between p-6">
    <VStack className="flex-1 justify-center items-center">
      <Badge>For you</Badge>
      <Traits active={true} />
      <Sticker />
    </VStack>
    <VStack>
      <Authorship />
      <Button onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" />
        <Text>Start</Text>
      </Button>
    </VStack>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
