import { cn } from "@/lib/utils";
import { Play, X, Maximize2, Wand2, Feather, Upload, ChevronDown, Check, Scan, Save } from "lucide-react";

const Icons = {
  Play, Exit: X, FullscreenExit: Maximize2, Magic: Wand2, Feather, Upload, ChevronDown, Check, Scan, Save
};

type Props = { variant: keyof typeof Icons; className?: string };
export const Glyph = ({ variant, className }: Props) => {
  const Icon = Icons[variant] || Icons.Magic;
  return <Icon className={cn("w-6 h-6", className)} />;
};
