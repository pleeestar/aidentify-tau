"use client";

import { ReactNode } from "react";
import { useSceneStore } from "@/store/scene.store";
import { motion } from "framer-motion";

const surfaceClassMap: Record<
  "gradientNoise" | "darkNoise",
  string
> = {
  gradientNoise: "noise-gradient-bg",
  darkNoise: "dark-noise-bg",
};

export const Surface = ({ children }: { children: ReactNode }) => {
  const surfaceSpec = useSceneStore((s) => s.surfaceSpec);
  const className = surfaceClassMap[surfaceSpec.kind];

  return (
    <motion.div
      key={surfaceSpec.kind} // keyを変更することでアニメーションをトリガー
      className={`relative w-full h-screen ${className} text-white overflow-hidden`}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.5, ease: "easeInOut" }}
    >
      {children}
    </motion.div>
  );
};
