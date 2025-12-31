import { cn } from "@/lib/utils";
export const Traits = ({ className, children, active, ...rest }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} data-active={active ? "true" : "false"} {...rest}>
    Traits {children}
  </div>
);
