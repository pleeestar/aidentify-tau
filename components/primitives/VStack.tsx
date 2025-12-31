import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const VStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-col", gap && `gap-${gap}`, className)} {...props}>{children}</div>
);
