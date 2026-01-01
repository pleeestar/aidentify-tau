import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack, Badge, Sticker, Authorship, Glyph, Text } from "@/components/primitives/";
import { Button, TraitsCarousel } from "@/components/assemblies/";

// Motion
import { motion } from "framer-motion";
import { staggerContainer, fadeInUp } from "@/motion/variants";

type TraitItem = {
  id: string;
  title: string;
  description?: string;
};

const SERVICE_TRAITS: TraitItem[] = [
  {
    id: "privacy",
    title: "個人情報を保護",
    description: "画像内の個人情報を自動で検出・保護",
  },
  {
    id: "local",
    title: "ローカル処理",
    description: "データを外に出さず端末内で完結",
  },
  {
    id: "fast",
    title: "高速処理",
    description: "待ち時間を感じさせない即時変換",
  },
  {
    id: "simple",
    title: "直感的UI",
    description: "説明不要のシンプル操作",
  },
  {
    id: "reliable",
    title: "安定した精度",
    description: "実運用を想定した堅牢な検出ロジック",
  },
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
        <Glyph variant="Upload" className="mr-2" /> Start
      </Button>
    </motion.div>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
