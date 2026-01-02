import { cn } from "@/lib/utils";
import Image from "next/image";

export const Authorship = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    <div className="relative w-full aspect-[4/1]">
      <Image
        src="/Authorship.svg"
        alt="Authorship"
        fill
        className="object-contain"
      />
    </div>
  </div>
);
