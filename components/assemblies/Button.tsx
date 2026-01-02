// components/assemblies/Button.tsx
"use client";

import { ReactNode } from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";
import { motion } from "framer-motion";

// 1. バリエーションの定義（ここがデザインシステムの中核）
const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-xl transition-all duration-200 active:scale-95 disabled:opacity-50 disabled:pointer-events-none",
  {
    variants: {
      variant: {
        // 白背景、黒文字
        primary: "bg-white text-black font-medium px-6 py-3",
        // 黒背景、白文字
        secondary: "bg-black text-white border border-white/10 font-mono px-6 py-3",
        // 透過グレー（px-8が確実に効くようにここに記述）
        ghost: "bg-white/10 text-white backdrop-blur-md hover:bg-white/20 border border-white/10 rounded-full px-3 py-1.5",
        // 四角いアイコン枠
        icon: "bg-transparent border border-white/5 p-2  bg-white/2.5 rounded-full",
      },
    },
    // デフォルト設定
    defaultVariants: {
      variant: "primary",
    },
  }
);

// TypeScriptの型定義（VariantPropsを使ってcvaの定義から自動生成）
interface ButtonProps 
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  children?: ReactNode;
}

export const Button = ({ children, variant, className, ...props }: ButtonProps) => {
  return (
    <motion.button
      whileTap={{ scale: 0.96 }}
      className={cn(buttonVariants({ variant }), className)}
      {...props}
    >
      {children}
    </motion.button>
  );
};