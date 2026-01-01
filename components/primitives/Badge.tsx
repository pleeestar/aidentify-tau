import { cn } from "@/lib/utils";

type BadgeProps = {
  children: React.ReactNode;
  variant?: "default" | "success" | "warning" | "error";
  className?: string;
};

export const Badge = ({
  children,
  variant = "default",
  className,
}: BadgeProps) => {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded border px-2 py-0.5 text-xs",
        {
          "border-white/10 text-white/80": variant === "default",
          "border-green-500/30 text-green-400": variant === "success",
          "border-yellow-500/30 text-yellow-400": variant === "warning",
          "border-red-500/30 text-red-400": variant === "error",
        },
        className
      )}
    >
      {children}
    </span>
  );
};
