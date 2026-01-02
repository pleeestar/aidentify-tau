import { LucideIcon } from "lucide-react";

type TraitProps = {
  title: string;
  icon: LucideIcon;
};

export const Trait = ({ title, icon: Icon }: TraitProps) => {
  return (
    <div className="flex items-center gap-1 p-3">
      <Icon className="w-6 h-6 w-10 h-10" />
      <span className="text-2xl font-bold">{title}</span>
    </div>
  );
};
