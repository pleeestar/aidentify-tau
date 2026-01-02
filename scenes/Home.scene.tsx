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
  PartyPopper
} from "lucide-react";
import { LucideIcon } from "lucide-react";

type TraitItem = {
  id: string;
  title: string;
  icon: LucideIcon;
};

const SERVICE_TRAITS: TraitItem[] = [
  {
    id: "party-popper",
    title: "明けおめことよろ！",
    icon: PartyPopper,
  },
  {
    id: "privacy",
    title: "AIが個人情報を保護",
    icon: ShieldUser,
  },
  {
    id: "ai-sort",
    title: "AIが画像を分別する",
    icon: Brain,
  },
  {
    id: "llm",
    title: "LMが危険を解析します",
    icon: ScanText,
  },
  {
    id: "no-learn",
    title: "学習には使いません",
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
        <Badge variant="default">For your privacy</Badge>
      </motion.div>

      <motion.div variants={fadeInUp}>
        <TraitsCarousel items={SERVICE_TRAITS} />
      </motion.div>

      <motion.div variants={fadeInUp}>
        <Sticker />
      </motion.div>

      <motion.div variants={fadeInUp}>
        <Text className="font-libre-barcode-128 text-4xl text-[#ffffff]">@pasokon_net</Text>
      </motion.div>
    </motion.div>

    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.5 }}
      className="flex flex-col gap-4"
    >
      <Authorship />
      <Button variant="secondary" onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" />
        <Text className="font-bold">画像をアップロード</Text>
      </Button>
    </motion.div>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  surface: { kind: "gradientNoise" },
  viewModel: useSceneVM,
  view: HomeView,
});
