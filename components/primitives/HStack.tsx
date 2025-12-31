import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const HStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-row items-center", gap && `gap-${gap}`, className)} {...props}>{children}</div>
);
