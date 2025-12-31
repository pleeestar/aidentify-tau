import { cn } from "@/lib/utils";
export const Tooltip = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    Tooltip {children}
  </div>
);
