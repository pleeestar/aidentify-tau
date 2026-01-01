type TraitProps = {
  title: string;
  description?: string;
};

export const Trait = ({ title, description }: TraitProps) => {
  return (
    <div className="flex flex-col gap-1 rounded border border-white/10 p-3 bg-black/20">
      <span className="text-sm font-medium">{title}</span>
      {description && (
        <span className="text-xs text-white/60">
          {description}
        </span>
      )}
    </div>
  );
};
