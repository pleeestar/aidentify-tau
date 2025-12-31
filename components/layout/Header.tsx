import { HeaderSpec } from "@/domain/types";
import { HStack } from "@/components/primitives/HStack";
import { Text } from "@/components/primitives/Text";
import { Glyph } from "@/components/primitives/Glyph";

export const Header = ({ spec, onAction }: { spec: HeaderSpec; onAction: () => void }) => {
  if (spec.kind === "none") return null;
  return (
    <header className="absolute top-0 w-full p-4 z-50 pointer-events-auto">
      <HStack className="justify-between">
        {spec.kind === "logo" ? <Text className="font-bold text-xl">aidentify</Text> : <Text className="font-bold">{spec.title}</Text>}
        {spec.action && (
          <button onClick={onAction}>
             <Glyph variant="Exit" />
          </button>
        )}
      </HStack>
    </header>
  );
};
