import { cn } from "@/lib/utils";
import Image from "next/image";

export const Authorship = ({ className, children, ...props }: any) => (
  <div className={cn("rounded flex justify-center", className)} {...props}>
    {/* なんでや阪神関係ないやろ！ */}
    <div className="relative w-full max-w-[334px] aspect-[4/1]">
      <Image
        src="/Authorship.svg"
        alt="Authorship"
        fill
        className="object-contain"
      />
    </div>
  </div>
);
