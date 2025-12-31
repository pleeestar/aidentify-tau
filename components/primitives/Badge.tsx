import { cn } from "@/lib/utils";
export const Badge = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    Badge {children}
  </div>
);
