"use client";

import { cn } from "@/lib/utils";
import { motion } from "framer-motion";

type IntentMeterProps = {
  label: string;
  index: number;
  className?: string;
};

/* ===============================
 * Geometry
 * =============================== */

const TICK_COUNT = 31;
const CENTER = Math.floor(TICK_COUNT / 2);

// 1 tick の実効幅 = width(2px) + mx(3px * 2)
const TICK_STEP = 8;

/* ===============================
 * Component
 * =============================== */

export const IntentMeter = ({
  label,
  index,
  className,
}: IntentMeterProps) => {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-start gap-3",
        className
      )}
    >
      {/* Label */}
      <div className="text-xl font-ibm-plex-mono tracking-wide font-light text-yellow-300/80">
        {label}
      </div>

      {/* Viewport */}
      <div className="relative w-[260px] h-6 overflow-hidden">
        {/* Track */}
        <motion.div
          className="absolute left-1/2 top-0 flex"
          animate={{
            // CENTER tick を常に中央に固定し、index 分だけ流す
            x: -(CENTER + index) * TICK_STEP,
          }}
          transition={{
            type: "spring",
            stiffness: 200,
            damping: 24,
          }}
        >
          {Array.from({ length: TICK_COUNT }).map((_, i) => {
            const logicalIndex = i - CENTER;

            // 意味論的中心（＝現在の Intent）
            const isCenter = logicalIndex + index === 0;

            // 5刻みのメジャー目盛り
            const isMajor = (logicalIndex + index) % 5 === 0;

            return (
              <div
                key={i}
                className={cn(
                  "rounded-full mx-[3px]",
                  isCenter
                    ? "w-[2px] h-6 bg-yellow-300/70"
                    : isMajor
                    ? "w-[2px] h-4 bg-yellow-400/40"
                    : "w-[2px] h-3 bg-yellow-500/20"
                )}
              />
            );
          })}
        </motion.div>
      </div>
    </div>
  );
};
