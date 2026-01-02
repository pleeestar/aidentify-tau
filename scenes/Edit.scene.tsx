import { createScene } from "./createScene";
import { useEditVM } from "@/viewmodel/edit.vm";
import { VStack, HStack, ZStack, Spacer, Text, Glyph } from "@/components/primitives/";
import { CropOverlay, IntentService, ModeCarouselService, Slider, Button } from "@/components/assemblies/";

const EditView = ({ vm }: { vm: ReturnType<typeof useEditVM> }) => (
  <div className="h-full w-full flex flex-col p-4">
    <VStack className="h-full" gap={4}>
       <Spacer />
       
       <VStack className="flex-1">
          <Text className="text-center opacity-70">Drag to adjust</Text>
          
          <ZStack as="Stage" className="flex-1 bg-zinc-900 rounded-lg overflow-hidden relative">
             <div className="absolute inset-0 bg-gray-800 opacity-50" /> {/* Image Placeholder */}
             <CropOverlay />
          </ZStack>

          <HStack as="Control" className="justify-between">
             <IntentService className="w-1/3" />
             <ModeCarouselService className="w-1/3" />
             <Button className="w-12 h-12 p-0">
               <Glyph variant="FullscreenExit" />
             </Button>
          </HStack>
       </VStack>

       <HStack as="Action" className="pt-4 border-t border-white/10">
          <Slider className="flex-1" />
          <Button onClick={vm.onPlay}>
             <Glyph variant="Play" />
          </Button>
       </HStack>
    </VStack>
  </div>
);

export const EditScene = createScene({
  header: { kind: "text", title: "Edit", action: "exit" },
  surface: { kind: "darkNoise" },
  viewModel: useEditVM,
  view: EditView,
});
