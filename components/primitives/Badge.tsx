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
        "inline-flex items-center rounded-full border px-2 py-0.5 text-sm font-medium",
        {
          "border-white/10 bg-white/10 text-white/100": variant === "default",
          "border-green-500/30 bg-green-500/10 text-green-400": variant === "success",
          "border-yellow-500/30 bg-yellow-500/10 text-yellow-400": variant === "warning",
          "border-red-500/30 bg-red-500/10 text-red-400": variant === "error",
        },
        className
      )}
    >
      {children}
    </span>
  );
};
