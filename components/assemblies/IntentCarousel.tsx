"use client";

import { motion } from "framer-motion";
import { useEffect, useRef, useState } from "react";
import { Intent, IntentLabel } from "@/domain/types";
import { useIntentStore } from "@/store/intent.store";
import { VStack } from "@/components/primitives";
import { IntentMeter } from "@/components/primitives/IntentMeter";

/* ===============================
 * Vocabulary
 * =============================== */

const INTENTS = [
  "mask",
  "blur",
  "pixelate",
  "remove",
  "auto",
] as const satisfies readonly Intent[];

/* ===============================
 * Layout semantics
 * =============================== */

const Layout = {
  itemSize: 84,
  frameSize: 89,
  gap: 10,
  inactiveScale: 0.9,
  frameBorder: 4,
  itemRadius: 14,
  frameRadius: 19,
} as const;

/* ===============================
 * Derived geometry
 * =============================== */

const STEP = Layout.itemSize + Layout.gap;
const ITEM_HALF = Layout.itemSize / 2;

/* ===============================
 * Component
 * =============================== */

export function IntentCarousel() {
  const viewportRef = useRef<HTMLDivElement>(null);

  const intent = useIntentStore((s) => s.intent);
  const setIntent = useIntentStore((s) => s.setIntent);

  const index = INTENTS.indexOf(intent);

  const [viewportWidth, setViewportWidth] = useState(0);
  useEffect(() => {
    if (!viewportRef.current) return;
    setViewportWidth(viewportRef.current.offsetWidth);
  }, []);

  // Carousel の不動点
  const centerX =
    viewportWidth / 2 - ITEM_HALF - index * STEP;

  const select = (i: number) => {
    setIntent(INTENTS[i]);
  };

  return (
    <VStack className="w-full items-center" gap={2}>
      {/* ===== Meter ===== */}
      <IntentMeter label={intent} index={index} />

      {/* ===== Carousel ===== */}
      <div
        ref={viewportRef}
        className="relative w-full h-28 overflow-hidden flex items-center"
      >
        {/* Selection Frame（不動点） */}
        <motion.div
          className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2
                     pointer-events-none z-10"
          style={{
            width: Layout.frameSize,
            height: Layout.frameSize,
            borderRadius: Layout.frameRadius,
            border: `${Layout.frameBorder}px solid white`,
          }}
          animate={{ scale: [1, 1.05, 1] }}
          transition={{
            duration: 1.2,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />

        {/* Intent Track */}
        <motion.div
          className="absolute flex items-center"
          drag="x"
          dragConstraints={{ left: centerX, right: centerX }}
          dragElastic={0.15}
          animate={{ x: centerX }}
          transition={{
            type: "spring",
            stiffness: 340,
            damping: 30,
          }}
          onDragEnd={(_, info) => {
            if (info.offset.x < -60 && index < INTENTS.length - 1) {
              select(index + 1);
            }
            if (info.offset.x > 60 && index > 0) {
              select(index - 1);
            }
          }}
        >
          {INTENTS.map((it, i) => {
            const active = i === index;

            return (
              <motion.div
                key={it}
                className="shrink-0 cursor-pointer overflow-hidden"
                style={{
                  width: Layout.itemSize,
                  height: Layout.itemSize,
                  borderRadius: Layout.itemRadius,
                  marginRight: Layout.gap,
                }}
                animate={{
                  scale: active ? 1 : Layout.inactiveScale,
                  opacity: active ? 1 : 0.5,
                }}
                transition={{ duration: 0.25 }}
                onClick={() => select(i)}
              >
                <img
                  src={`/intents/${it}.png`}
                  alt={IntentLabel[it]}
                  className="h-full w-full object-cover"
                />
              </motion.div>
            );
          })}
        </motion.div>
      </div>
    </VStack>
  );
}
