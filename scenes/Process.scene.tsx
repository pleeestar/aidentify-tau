import { createScene } from "./createScene";
import { useProcessVM } from "@/viewmodel/process.vm";
import { VStack } from "@/components/primitives/VStack";
import { Traits } from "@/components/primitives/Traits";
import { Text } from "@/components/primitives/Text";
import { Spinner } from "@/components/primitives/Spinner";
import { Authorship } from "@/components/primitives/Authorship";

const ProcessView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-center items-center" gap={8}>
      <Traits active={false} />
      <Text className="animate-pulse">AI is processing... {vm.progress}%</Text>
      <Spinner />
      <Authorship />
  </VStack>
);

export const ProcessScene = createScene({
  header: { kind: "none" },
  viewModel: useProcessVM,
  view: ProcessView,
});
