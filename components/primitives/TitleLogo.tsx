import { cn } from "@/lib/utils";
import Image from "next/image";

export const TitleLogo = ({ className }: { className?: string }) => (
  <div className={cn("relative h-10 aspect-[3/1]", className)}>
    <Image
      src="/Logo.svg"
      alt="Aidentify"
      fill
      className="object-contain"
      priority
    />
  </div>
);
