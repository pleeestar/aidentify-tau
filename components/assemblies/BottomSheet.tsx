import { ReactNode } from "react";
import { VStack, HStack, Text } from "@/components/primitives/";

export const BottomSheet = ({ title, subtitle, children }: { title?: string; subtitle?: string; children: ReactNode }) => (
  <div className="absolute bottom-0 w-full bg-[#252525] rounded-t-3xl px-5 pt-1 pb-5 shadow-2xl border border-white/10">
    <VStack gap={4}>
      <div className="w-14 h-1.5 bg-[#050505] rounded-full mx-auto" />
      {(title || subtitle) && (
        <HStack gap={2} className="justify-between">
          <VStack gap={1}>
            {title && <Text className="text-[#ffffff48] text-3xl font-bold font-knewave">{title}</Text>}
            {subtitle && <Text className="text-base font-bold font-inter text-[#ffffff56]">{subtitle}</Text>}
          </VStack>
          <Text className="font-libre-barcode-128 text-2xl text-[#ffffff25]">@pallet-cmp</Text>
        </HStack>
      )}
      {children}
    </VStack>
  </div>
);
