"use client";
import { Surface } from "@/components/layout/Surface";
import { Header } from "@/components/layout/Header";
import { SceneRenderer } from "@/components/SceneRenderer";
import { AnimatePresence } from "framer-motion";
import { useSceneStore } from "@/store/scene.store";

export default function Page() {
  const surfaceSpec = useSceneStore((s) => s.surfaceSpec);

  return (
    <AnimatePresence mode="wait">
      <Surface key={surfaceSpec.kind}>
        <Header />
        <main className="w-full h-full">
          <SceneRenderer />
        </main>
      </Surface>
    </AnimatePresence>
  );
}
