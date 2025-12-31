import { cn } from "@/lib/utils";
export const TitleLogo = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    TitleLogo {children}
  </div>
);
