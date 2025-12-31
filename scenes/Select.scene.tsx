import { createScene } from "./createScene";
import { useIntentVM } from "@/viewmodel/intent.vm";
import { VStack } from "@/components/primitives/VStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { Tooltip } from "@/components/primitives/Tooltip";
import { IntentService } from "@/components/assemblies/IntentService";
import { ModeCarouselService } from "@/components/assemblies/ModeCarouselService";

const SelectView = ({ vm }: { vm: any }) => (
  <>
    {/* Overlay */}
    <div className="absolute inset-0 z-20 pointer-events-none flex flex-col justify-end">
      <div className="pointer-events-auto">
        <BottomSheet title="Intent" subtitle="12 Intents">
            <VStack>
                <Tooltip text="Select an intent" />
                <IntentService onClick={vm.onSelectIntent} />
            </VStack>
        </BottomSheet>
      </div>
    </div>

    {/* Content */}
    <VStack className="h-full pt-20 px-4">
        <ModeCarouselService />
    </VStack>
  </>
);

export const SelectScene = createScene({
  header: { kind: "text", title: "Select", action: "exit" },
  viewModel: useIntentVM,
  view: SelectView,
});
