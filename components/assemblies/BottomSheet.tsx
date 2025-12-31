import { ReactNode } from "react";
import { VStack } from "@/components/primitives/VStack";
import { Text } from "@/components/primitives/Text";

export const BottomSheet = ({ title, subtitle, children }: { title?: string; subtitle?: string; children: ReactNode }) => (
  <div className="absolute bottom-0 w-full bg-[#1A1A1A] rounded-t-3xl p-6 shadow-2xl border-t border-white/10">
    <VStack gap={4}>
      <div className="w-12 h-1 bg-white/20 rounded-full mx-auto" />
      {(title || subtitle) && (
        <div>
          {title && <Text className="text-xl font-bold">{title}</Text>}
          {subtitle && <Text className="text-xs opacity-50">{subtitle}</Text>}
        </div>
      )}
      {children}
    </VStack>
  </div>
);
