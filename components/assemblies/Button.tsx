import { ReactNode } from "react";
import { cn } from "@/lib/utils";
export const Button = ({ children, className, onClick }: { children: ReactNode; className?: string; onClick?: () => void }) => (
  <button onClick={onClick} className={cn("flex items-center justify-center bg-white/10 hover:bg-white/20 active:scale-95 transition-all rounded-full h-12 px-6", className)}>
    {children}
  </button>
);
