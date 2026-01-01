import { createScene } from "./createScene";
import { useProcessVM } from "@/viewmodel/process.vm";
import { VStack } from "@/components/primitives/VStack";
import { TraitsCarousel } from "@/components/assemblies/TraitsCarousel";
import { Text } from "@/components/primitives/Text";
import { Spinner } from "@/components/primitives/Spinner";
import { Authorship } from "@/components/primitives/Authorship";
import { motion } from "framer-motion";

const ProcessView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-center items-center" gap={8}>
      <motion.div 
        animate={{ scale: [1, 1.1, 1], opacity: [0.5, 1, 0.5] }} 
        transition={{ repeat: Infinity, duration: 2 }}
      >
        <TraitsCarousel />
      </motion.div>

      <Text className="animate-pulse">AI is processing... {vm.progress}%</Text>
      
      <Spinner />
      
      <motion.div 
        initial={{ opacity: 0 }} 
        animate={{ opacity: 1 }} 
        transition={{ delay: 1 }}
      >
        <Authorship />
      </motion.div>
  </VStack>
);

export const ProcessScene = createScene({
  header: { kind: "none" },
  viewModel: useProcessVM,
  view: ProcessView,
});
