import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; as?: any };
export const ZStack = ({ children, className, ...props }: Props) => (
  <div className={cn("grid place-items-center > *", className)} {...props}>
    {children}
    <style jsx>{`div > * { grid-area: 1 / 1; width: 100%; height: 100%; }`}</style>
  </div>
);
