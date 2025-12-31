import { ReactNode } from "react";
import { cn } from "@/lib/utils";
export const Text = ({ children, className }: { children: ReactNode; className?: string }) => (
  <p className={cn("text-white/90 font-sans", className)}>{children}</p>
);
