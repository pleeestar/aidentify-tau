"use client";
import { useSceneStore } from "@/store/scene.store";
import { HStack } from "@/components/primitives/HStack";
import { Text } from "@/components/primitives/Text";
import { Glyph } from "@/components/primitives/Glyph";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { AnimatePresence, motion } from "framer-motion";
import { fadeInUp } from "@/motion/variants";

import { Button } from "../assemblies";
import { TitleLogo } from "../primitives";

export const Header = () => {
  const scene = useSceneStore((s) => s.scene);
  const { onExit } = useSceneVM(); // 共通の終了ロジック

  // Sceneごとの設定を定義
  const specs: Record<string, { title?: string; kind: "logo" | "text" | "none"; action?: boolean }> = {
    home: { kind: "logo", action: false },
    select: { kind: "text", title: "Select", action: true },
    edit: { kind: "text", title: "Edit", action: true },
    process: { kind: "none" },
    result: { kind: "text", title: "Result", action: true },
  };

  const spec = specs[scene] || specs.home;

  if (spec.kind === "none") return <div className="h-20" />; // スペースだけ確保

  return (
    <header className="fixed top-0 w-full p-6 z-50">
      <HStack className="justify-between">
        <AnimatePresence mode="wait">
          <motion.div
            key={`header-title-${scene}`}
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            exit="hidden"
            transition={{ duration: 0.3 }}
          >
            {spec.kind === "logo" ? (
              <TitleLogo />
            ) : (
              <Text className="text-2xl font-knewave">{spec.title}</Text>
            )}
          </motion.div>
        </AnimatePresence>
        
        <AnimatePresence mode="wait">
          <motion.div
            key={`header-action-${scene}`}
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            exit="hidden"
            transition={{ duration: 0.3 }}
          >
            {spec.kind === "logo" ? (
              <Button variant="ghost" onClick={() => alert("Login action")}>
                <Text>Login</Text>
              </Button>
            ) : (
              <Button variant="icon" onClick={onExit}>
                 <Glyph variant="Exit" className="w-5 h-5" />
              </Button>
            )}
          </motion.div>
        </AnimatePresence>
      </HStack>
    </header>
  );
};
