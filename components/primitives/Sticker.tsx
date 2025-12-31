import { cn } from "@/lib/utils";
export const Sticker = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    Sticker {children}
  </div>
);
