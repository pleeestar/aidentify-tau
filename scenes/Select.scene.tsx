import { createScene } from "./createScene";
import { useIntentVM } from "@/viewmodel/intent.vm";
import { VStack } from "@/components/primitives/VStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { IntentMeter } from "@/components/primitives/IntentMeter";
import { IntentCarousel } from "@/components/assemblies/IntentCarousel";
import { ModeCarouselService } from "@/components/assemblies/ModeCarouselService";
import { useIntentStore } from "@/store/intent.store";
//import { IntentLabel } from "@/domain/types";


const SelectView = ({ vm }: { vm: any }) => (
  <>
    {/* Overlay */}
    <div className="absolute inset-0 z-20 pointer-events-none flex flex-col justify-end">
      <div className="pointer-events-auto">
        <BottomSheet title="Pallet" subtitle="12 Intents">
          <IntentCarousel onClick={vm.onSelectIntent} />
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
  surface: { kind: "darkNoise" },
  viewModel: useIntentVM,
  view: SelectView,
});
