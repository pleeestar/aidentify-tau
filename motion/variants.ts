import { Variants } from "framer-motion";

// 画面遷移の標準アニメーション
export const pageTransition: Variants = {
  initial: { opacity: 0, scale: 0.98, filter: "blur(10px)" },
  animate: { opacity: 1, scale: 1, filter: "blur(0px)" },
  exit: { opacity: 0, scale: 1.02, filter: "blur(10px)" },
};

// コンテナ内の要素を順番に出現させる (Stagger)
export const staggerContainer: Variants = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2,
    },
  },
};

// 下からふわっと浮き上がる要素
export const fadeInUp: Variants = {
  hidden: { opacity: 0, y: 20, filter: "blur(5px)" },
  show: {
    opacity: 1,
    y: 0,
    filter: "blur(0px)",
    transition: { type: "spring", stiffness: 100, damping: 15 }
  },
};

// ポップアップ系 (BottomSheetなど)
export const slideUp: Variants = {
  hidden: { y: "100%" },
  show: { y: 0, transition: { type: "spring", stiffness: 300, damping: 30 } },
  exit: { y: "100%" },
};

// TraitsCarousel 用の垂直サイクルアニメーション
export const verticalCycle: Variants = {
  enter: { 
    y: -20, // 上から入る
    opacity: 0 
  },
  center: { 
    y: 0, 
    opacity: 1 
  },
  exit: { 
    y: 20, // 下に抜ける
    opacity: 0,
    position: "absolute" // 抜ける瞬間に場所を空ける
  },
};