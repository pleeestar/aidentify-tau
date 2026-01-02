import { cn } from "@/lib/utils";
import Image from "next/image";

export const Sticker = ({ className, children, ...props }: any) => (
  <div className={cn("p-2 rounded", className)} {...props}>
    <Image
      src="/sticker.png"
      alt="Sticker"
      width={100}
      height={100}
      className="object-contain"
    />
  </div>
);
