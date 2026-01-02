import { Variants } from "framer-motion";

// iOS風の画面遷移アニメーション（下から上にスライド）
export const pageTransitionForward: Variants = {
  initial: { 
    y: "100%", // 画面下から開始
    opacity: 0 
  },
  animate: { 
    y: 0, // 通常位置に
    opacity: 1,
    transition: { 
      type: "spring", 
      stiffness: 300, 
      damping: 30,
      mass: 0.8
    }
  },
  exit: { 
    y: "-100%", // 画面上に退場
    opacity: 0,
    transition: { 
      type: "spring", 
      stiffness: 300, 
      damping: 30,
      mass: 0.8
    }
  },
};

// iOS風の画面遷移アニメーション（上から下にスライド - 戻る時）
export const pageTransitionBackward: Variants = {
  initial: { 
    y: "-100%", // 画面上から開始
    opacity: 0 
  },
  animate: { 
    y: 0, // 通常位置に
    opacity: 1,
    transition: { 
      type: "spring", 
      stiffness: 300, 
      damping: 30,
      mass: 0.8
    }
  },
  exit: { 
    y: "100%", // 画面下に退場
    opacity: 0,
    transition: { 
      type: "spring", 
      stiffness: 300, 
      damping: 30,
      mass: 0.8
    }
  },
};

// 後方互換性のため
export const pageTransition = pageTransitionForward;

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