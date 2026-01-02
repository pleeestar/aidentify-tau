import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack, Badge, Sticker, Authorship, Glyph, Text } from "@/components/primitives/";
import { Button, TraitsCarousel } from "@/components/assemblies/";

// Motion
import { motion } from "framer-motion";
import { staggerContainer, fadeInUp } from "@/motion/variants";

// Icons
import {
  ShieldUser,
  Brain,
  ScanText,
  Cctv,
  Bird,
} from "lucide-react";

type TraitItem = {
  id: string;
  title: string;
  icon?: string;
};

const SERVICE_TRAITS: TraitItem[] = [
  {
    id: "privacy",
    title: "AI個人情報を保護",
    icon: ShieldUser,
  },
  {
    id: "ai-sort",
    title: "AIが画像を分別し",
    icon: Brain,
  },
  {
    id: "llm",
    title: "LLMが危険を解析",
    icon: ScanText,
  },
  {
    id: "no-learn",
    title: "学習に使いません",
    icon: Cctv,
  },
  {
    id: "safety",
    title: "安心なネットライフ",
    icon: Bird,
  }
];


const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between p-6">

    {/* Stagger Animation applied to the container */}
    <motion.div
      variants={staggerContainer}
      initial="hidden"
      animate="show"
      exit="exit"
      className="flex-1 flex flex-col justify-center items-center gap-6"
    >
      <motion.div variants={fadeInUp}>
        <Badge>For your privacy</Badge>
      </motion.div>

      <motion.div variants={fadeInUp}>
        <TraitsCarousel items={SERVICE_TRAITS} />
      </motion.div>

      <motion.div variants={fadeInUp}>
        <Sticker />
      </motion.div>
    </motion.div>

    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.5 }}
      className="flex flex-col gap-4"
    >
      <Authorship />
      <Button onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" />
        <Text>Start</Text>
      </Button>
    </motion.div>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
