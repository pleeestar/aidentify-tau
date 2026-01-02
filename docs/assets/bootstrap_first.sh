#!/bin/bash
set -e

echo "🚀 Initializing aidentify v3.0 (Strict Architecture) based on Design..."

# ==========================================
# 1. Project Foundation & Dependencies
# ==========================================
echo "📦 Installing core dependencies..."
npm install zustand framer-motion clsx tailwind-merge lucide-react

# Directory Structure
mkdir -p src/app
mkdir -p src/components/primitives
mkdir -p src/components/assemblies
mkdir -p src/components/layout
mkdir -p src/scenes
mkdir -p src/viewmodel
mkdir -p src/store
mkdir -p src/motion
mkdir -p src/domain
mkdir -p src/infra
mkdir -p src/lib

# Utility
cat <<'TS' > src/lib/utils.ts
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
TS

# ==========================================
# 2. Domain Layer (Types)
# ==========================================
echo "💎 Generating Domain Types..."
cat <<'TS' > src/domain/types.ts
export type SceneKind = "home" | "select" | "edit" | "process" | "result";
export type Intent = "nature" | "urban" | "portrait" | "privacy" | "auto";
export type EditMode = "crop" | "tune" | "magic";

export type HeaderSpec = 
  | { kind: "logo"; action?: "login" }
  | { kind: "text"; title: string; action?: "exit" | "back" | "cancel" }
  | { kind: "none" };
TS

# ==========================================
# 3. Primitives Layer (Atomic UI)
# ==========================================
echo "🧱 Generating Primitives (from primitives.png)..."

# Layout Primitives (SwiftUI-like Stacks)
cat <<'TS' > src/components/primitives/HStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const HStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-row items-center", `gap-${gap}`, className)} {...props}>{children}</div>
);
TS

cat <<'TS' > src/components/primitives/VStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const VStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-col", `gap-${gap}`, className)} {...props}>{children}</div>
);
TS

cat <<'TS' > src/components/primitives/ZStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; as?: any };
export const ZStack = ({ children, className, ...props }: Props) => (
  <div className={cn("grid place-items-center > *", className)} {...props}>{children}</div>
);
TS

cat <<'TS' > src/components/primitives/Space.tsx
export const Space = ({ size = 4 }: { size?: number }) => <div style={{ flexGrow: 1, minHeight: size }} />;
TS

cat <<'TS' > src/components/primitives/Frame.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";
export const Frame = ({ children, className }: { children?: ReactNode, className?: string }) => (
  <div className={cn("relative overflow-hidden rounded-2xl bg-white/5 border border-white/10 backdrop-blur-sm", className)}>
    {children}
  </div>
);
TS

# UI Elements from Design
cat <<'TS' > src/components/primitives/Text.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";
type Props = { children: ReactNode; className?: string; variant?: "body" | "caption" | "title" };
export const Text = ({ children, className, variant = "body" }: Props) => {
  const styles = {
    body: "text-white/90 text-base",
    caption: "text-white/50 text-xs",
    title: "text-white font-bold text-xl"
  };
  return <p className={cn(styles[variant], "font-sans", className)}>{children}</p>;
};
TS

cat <<'TS' > src/components/primitives/TitleLogo.tsx
import { cn } from "@/lib/utils";
export const TitleLogo = ({ className }: { className?: string }) => (
  <h1 className={cn("text-5xl font-bold tracking-tighter text-white italic", className)} style={{ fontFamily: 'cursive' }}>
    Aidentify
  </h1>
);
TS

cat <<'TS' > src/components/primitives/Authorship.tsx
import { Text } from "./Text";
export const Authorship = () => (
  <div className="opacity-30 flex flex-col items-center">
    {/* Placeholder for the barcode/text footer seen in Home/Select */}
    <div className="h-4 w-32 bg-current mb-1" style={{ maskImage: 'linear-gradient(to right, transparent 2px, black 2px)' }}></div>
    <Text variant="caption">For your privacy | v0.20251229</Text>
  </div>
);
TS

cat <<'TS' > src/components/primitives/Sticker.tsx
import { cn } from "@/lib/utils";
// Placeholder for the Polaroid Camera Sticker
export const Sticker = ({ className }: { className?: string }) => (
  <div className={cn("w-40 h-40 bg-zinc-800 rounded-lg border-4 border-white shadow-xl rotate-[-4deg]", className)}>
    <div className="w-full h-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center">
      📸
    </div>
  </div>
);
TS

cat <<'TS' > src/components/primitives/Glyph.tsx
import { cn } from "@/lib/utils";
import { Play, X, Maximize2, Wand2, Feather, Upload, ChevronDown, Check, Crop, Sliders } from "lucide-react";

// Mapping icons from primitives.png
const Icons = {
  Play, Exit: X, FullscreenExit: Maximize2, Magic: Wand2, 
  Feather, Upload, ChevronDown, Check, Crop, Tune: Sliders
};

type Props = { variant: keyof typeof Icons; className?: string };
export const Glyph = ({ variant, className }: Props) => {
  const Icon = Icons[variant] || Icons.Magic;
  return <Icon className={cn("w-6 h-6", className)} />;
};
TS

cat <<'TS' > src/components/primitives/Badge.tsx
import { cn } from "@/lib/utils";
export const Badge = ({ label, className }: { label: string; className?: string }) => (
  <span className={cn("px-3 py-1 bg-white/10 rounded-full text-xs font-medium text-white backdrop-blur-md", className)}>
    {label}
  </span>
);
TS

cat <<'TS' > src/components/primitives/Traits.tsx
import { Text } from "./Text";
import { Glyph } from "./Glyph";
export const Traits = ({ active }: { active?: boolean }) => (
  <div className="flex flex-row items-center gap-2">
    <Glyph variant="Feather" className="w-8 h-8 text-white" />
    <Text className="text-2xl font-bold">個人情報を保護</Text>
  </div>
);
TS

cat <<'TS' > src/components/primitives/Spinner.tsx
export const Spinner = ({ size = "md" }: { size?: "sm" | "md" | "lg" }) => (
  <div className="animate-spin rounded-full border-2 border-white/20 border-t-white h-12 w-12" />
);
TS

cat <<'TS' > src/components/primitives/Tooltip.tsx
import { Text } from "./Text";
export const Tooltip = ({ text }: { text: string }) => (
  <div className="bg-black/80 px-4 py-2 rounded-lg relative mb-2">
    <Text variant="caption">{text}</Text>
    <div className="absolute bottom-[-6px] left-1/2 -translate-x-1/2 w-3 h-3 bg-black/80 rotate-45" />
  </div>
);
TS

cat <<'TS' > src/components/primitives/Card.tsx
import { ReactNode } from "react";
import { Frame } from "./Frame";
export const Card = ({ children, className }: { children: ReactNode; className?: string }) => (
  <Frame className={className}>{children}</Frame>
);
TS

# ==========================================
# 4. Assemblies Layer (Dynamic Components)
# ==========================================
echo "🧩 Generating Assemblies (from assemblies.png)..."

cat <<'TS' > src/components/assemblies/Button.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";
import { Frame } from "../primitives/Frame";

type Props = { children: ReactNode; variant?: "primary" | "secondary" | "icon" | "ghost"; className?: string; onClick?: () => void };

export const Button = ({ children, variant = "primary", className, onClick }: Props) => {
  const base = "flex items-center justify-center transition-transform active:scale-95 cursor-pointer";
  const styles = {
    primary: "bg-white text-black font-bold h-14 rounded-full px-8", // White button
    secondary: "bg-black/50 text-white font-bold h-14 rounded-full px-8 border border-white/10", // Black button
    icon: "w-12 h-12 rounded-full bg-white/10 backdrop-blur-md", // Icon circle
    ghost: "bg-transparent text-white"
  };
  
  return (
    <button className={cn(base, styles[variant], className)} onClick={onClick}>
      {children}
    </button>
  );
};
TS

cat <<'TS' > src/components/assemblies/BottomSheet.tsx
import { ReactNode } from "react";
import { VStack } from "../primitives/VStack";
import { Text } from "../primitives/Text";
import { Authorship } from "../primitives/Authorship";

type Props = { title?: string; subtitle?: string; children: ReactNode };

export const BottomSheet = ({ title, subtitle, children }: Props) => (
  <div className="absolute bottom-0 w-full bg-[#1A1A1A] rounded-t-[32px] p-6 pb-10 shadow-2xl border-t border-white/5">
    <div className="w-12 h-1 bg-white/20 rounded-full mx-auto mb-6" />
    <div className="flex justify-between items-start mb-6">
      <VStack gap={1} className="items-start">
        {title && <Text className="text-3xl font-serif italic">{title}</Text>}
        {subtitle && <Text variant="caption">{subtitle}</Text>}
      </VStack>
      <Authorship />
    </div>
    {children}
  </div>
);
TS

cat <<'TS' > src/components/assemblies/ModeCarouselService.tsx
import { HStack } from "../primitives/HStack";
import { Text } from "../primitives/Text";
import { Frame } from "../primitives/Frame";
import { Glyph } from "../primitives/Glyph";

// Matches "Auto / Crop / Controller" in assemblies.png
export const ModeCarouselService = ({ currentMode }: { currentMode?: string }) => (
  <HStack className="w-full overflow-x-auto px-4 pb-4" gap={4}>
    {['Auto', 'Crop', 'Tune'].map((m) => (
      <div key={m} className={`flex flex-col items-center gap-2 ${currentMode === m ? 'opacity-100' : 'opacity-50'}`}>
        <Frame className="w-24 h-24 flex items-center justify-center bg-white/5">
           <Text variant="caption">({m}Image)</Text>
        </Frame>
        <HStack gap={1}>
           <Glyph variant={m === 'Crop' ? 'Crop' : m === 'Tune' ? 'Tune' : 'Magic'} className="w-3 h-3" />
           <Text variant="caption">{m}</Text>
        </HStack>
      </div>
    ))}
  </HStack>
);
TS

cat <<'TS' > src/components/assemblies/Slider.tsx
import { Frame } from "../primitives/Frame";
import { Glyph } from "../primitives/Glyph";

// Matches the slider in assemblies.png
export const Slider = ({ className }: { className?: string }) => (
  <Frame className={`h-12 flex items-center px-4 bg-white/5 rounded-full ${className}`}>
    <Glyph variant="Tune" className="mr-4 opacity-50 w-4 h-4" />
    <div className="flex-1 h-1 bg-white/20 rounded-full relative">
      <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1/2 h-full bg-white rounded-full" />
      <div className="absolute left-1/2 top-1/2 -translate-y-1/2 w-6 h-6 bg-white rounded-full shadow-lg" />
    </div>
  </Frame>
);
TS

cat <<'TS' > src/components/assemblies/CropOverlay.tsx
// Matches the crop corners in assemblies.png
export const CropOverlay = () => (
  <div className="absolute inset-0 border-2 border-white/20 m-4 rounded-lg">
    <div className="absolute top-0 left-0 w-4 h-4 border-t-4 border-l-4 border-white rounded-tl-sm" />
    <div className="absolute top-0 right-0 w-4 h-4 border-t-4 border-r-4 border-white rounded-tr-sm" />
    <div className="absolute bottom-0 left-0 w-4 h-4 border-b-4 border-l-4 border-white rounded-bl-sm" />
    <div className="absolute bottom-0 right-0 w-4 h-4 border-b-4 border-r-4 border-white rounded-br-sm" />
  </div>
);
TS

cat <<'TS' > src/components/assemblies/IntentService.tsx
import { HStack } from "../primitives/HStack";
import { Text } from "../primitives/Text";
import { Frame } from "../primitives/Frame";

// Matches "Pallet" thumbnail grid in assemblies.png
export const IntentService = () => (
  <HStack className="overflow-x-auto w-full no-scrollbar" gap={3}>
    {[1,2,3,4].map(i => (
      <Frame key={i} className={`w-20 h-20 flex-shrink-0 ${i === 3 ? 'border-2 border-white' : ''}`}>
        {/* Placeholder image logic */}
        <div className="w-full h-full bg-gradient-to-t from-black/50 to-transparent" />
      </Frame>
    ))}
  </HStack>
);
TS

# ==========================================
# 5. Layout Layer
# ==========================================
echo "🖼 Generating Layout..."

cat <<'TS' > src/components/layout/Header.tsx
import { HeaderSpec } from "@/domain/types";
import { HStack } from "@/components/primitives/HStack";
import { Text } from "@/components/primitives/Text";
import { TitleLogo } from "@/components/primitives/TitleLogo";
import { Glyph } from "@/components/primitives/Glyph";
import { Button } from "@/components/assemblies/Button";

export const Header = ({ spec, onAction }: { spec: HeaderSpec; onAction: () => void }) => {
  if (spec.kind === "none") return null;
  return (
    <header className="absolute top-0 w-full p-6 z-50">
      <HStack className="justify-between w-full">
        {spec.kind === "logo" ? (
          <TitleLogo className="text-3xl" />
        ) : (
          <Text className="text-3xl font-serif italic text-white/80">{spec.title}</Text>
        )}
        
        {spec.action && (
          <Button variant="ghost" onClick={onAction} className="p-2">
             {spec.action === 'login' ? <div className="bg-white/20 px-4 py-1 rounded-full text-sm">Login</div> : <Glyph variant={spec.action === 'back' ? 'Exit' : 'Exit'} className="bg-white/10 rounded-full p-1 w-8 h-8" />}
          </Button>
        )}
      </HStack>
    </header>
  );
};
TS

cat <<'TS' > src/components/layout/Surface.tsx
import { ReactNode } from "react";
export const Surface = ({ children }: { children: ReactNode }) => (
  <div className="relative w-full h-screen bg-black text-white overflow-hidden font-sans selection:bg-indigo-500/30">
    {/* Blue gradient background from screenshots */}
    <div className="absolute inset-0 bg-gradient-to-b from-[#4A90E2]/80 via-[#A4D7F5]/20 to-[#F2F2F0] opacity-40 pointer-events-none" />
    {/* Noise texture overlay could go here */}
    {children}
  </div>
);
TS

# ==========================================
# 6. Adapter Layer (createScene)
# ==========================================
echo "🔌 Generating Adapter (createScene)..."

cat <<'TS' > src/scenes/createScene.tsx
import { ReactNode } from "react";
import { HeaderSpec } from "@/domain/types";
import { Header } from "@/components/layout/Header";
import { Surface } from "@/components/layout/Surface";

type AdapterConfig<VM> = {
  header: HeaderSpec;
  viewModel: () => VM;
  view: (props: { vm: VM }) => ReactNode;
};

export function createScene<VM>(config: AdapterConfig<VM>) {
  return function SceneAdapter() {
    const vm = config.viewModel();
    // In a real app, strict type guards would be here
    const handleAction = (vm as any).onHeaderAction || (() => console.log("Header Action Triggered"));

    return (
      <Surface>
        <Header spec={config.header} onAction={handleAction} />
        <div className="w-full h-full relative flex flex-col">
          <config.view vm={vm} />
        </div>
      </Surface>
    );
  };
}
TS

# ==========================================
# 7. Stores & VMs (Stubs)
# ==========================================
echo "🧠 Generating Logic Stubs..."
cat <<'TS' > src/store/app.store.ts
import { create } from "zustand";
import { SceneKind } from "@/domain/types";
export const useAppStore = create<{ scene: SceneKind; setScene: (s: SceneKind) => void }>((set) => ({
  scene: "home", setScene: (scene) => set({ scene }),
}));
TS
# Generate basic VMs
for name in scene intent edit process; do
  echo "export const use${name^}VM = () => ({});" > src/viewmodel/$name.vm.ts
done

# ==========================================
# 8. Scenes Implementation (The Core Request)
# ==========================================
echo "🎬 Generating Scenes based on Viewport Images..."

# --- HOME SCENE ---
cat <<'TS' > src/scenes/Home.scene.tsx
import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { Badge } from "@/components/primitives/Badge";
import { Traits } from "@/components/primitives/Traits";
import { Sticker } from "@/components/primitives/Sticker";
import { Authorship } from "@/components/primitives/Authorship";
import { Button } from "@/components/assemblies/Button";
import { Glyph } from "@/components/primitives/Glyph";

// Matches viewport(HomeScreen).png
const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between pb-10 pt-32 px-6" gap={0}>
    {/* Center Content */}
    <VStack className="flex-1 justify-center items-center" gap={6}>
      <Badge label="For you" />
      <Traits active={true} />
      <Sticker className="mt-4" />
    </VStack>

    {/* Bottom Content */}
    <VStack gap={4} className="w-full">
      <Authorship />
      <Button variant="secondary" className="w-full" onClick={() => console.log("Upload")}>
        画像をアップロード
      </Button>
    </VStack>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
TS

# --- SELECT SCENE ---
cat <<'TS' > src/scenes/Select.scene.tsx
import { createScene } from "./createScene";
import { useIntentVM } from "@/viewmodel/intent.vm";
import { VStack } from "@/components/primitives/VStack";
import { ZStack } from "@/components/primitives/ZStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { Tooltip } from "@/components/primitives/Tooltip";
import { IntentService } from "@/components/assemblies/IntentService";
import { ModeCarouselService } from "@/components/assemblies/ModeCarouselService";
import { Frame } from "@/components/primitives/Frame";
import { Text } from "@/components/primitives/Text";
import { Glyph } from "@/components/primitives/Glyph";

// Matches viewport(ImageSelectorScreen).png
const SelectView = ({ vm }: { vm: any }) => (
  <>
    {/* Main Content: Preview with Crop Indicator */}
    <VStack className="h-full pt-24 px-4">
      <div className="flex items-center gap-2 mb-2 opacity-70">
         <Glyph variant="Crop" className="w-4 h-4" />
         <Text className="font-bold">Crop</Text>
      </div>
      
      <Frame className="w-full aspect-square bg-zinc-900 relative">
        <ZStack className="w-full h-full">
          <Text variant="title">(EditImage)</Text>
          <div className="absolute inset-0 bg-black/20" />
        </ZStack>
      </Frame>
    </VStack>

    {/* Overlay: Pallet Selector */}
    <BottomSheet title="Pallet" subtitle="12パレット">
      <VStack gap={6}>
        <div className="flex justify-center">
           <Tooltip text="自然に注目" />
        </div>
        <IntentService />
      </VStack>
    </BottomSheet>
  </>
);

export const SelectScene = createScene({
  header: { kind: "text", title: "Select", action: "exit" },
  viewModel: useIntentVM,
  view: SelectView,
});
TS

# --- EDIT SCENE ---
cat <<'TS' > src/scenes/Edit.scene.tsx
import { createScene } from "./createScene";
import { useEditVM } from "@/viewmodel/edit.vm";
import { VStack } from "@/components/primitives/VStack";
import { HStack } from "@/components/primitives/HStack";
import { ZStack } from "@/components/primitives/ZStack";
import { Text } from "@/components/primitives/Text";
import { Frame } from "@/components/primitives/Frame";
import { Glyph } from "@/components/primitives/Glyph";
import { Slider } from "@/components/assemblies/Slider";
import { Button } from "@/components/assemblies/Button";
import { Tooltip } from "@/components/primitives/Tooltip";
import { CropOverlay } from "@/components/assemblies/CropOverlay";

// Matches viewport(EditorScreen).png
const EditView = ({ vm }: { vm: any }) => (
  <VStack className="h-full pb-8 pt-20" gap={0}>
    
    {/* Instructions */}
    <Text variant="caption" className="text-center mb-4 opacity-70">
      フィルタリングの厳しさをスライダーで調整してください
    </Text>

    {/* Stage */}
    <ZStack className="flex-1 w-full relative bg-zinc-900 overflow-hidden">
      {/* <Image /> */}
      <Text className="opacity-50">(Edit Image)</Text>
      <CropOverlay />
    </ZStack>

    {/* Controls Area (Black Background) */}
    <div className="w-full bg-[#111] px-4 py-6 rounded-t-3xl mt-[-20px] relative z-10">
      <VStack gap={6}>
        
        {/* Intent & Mode Row */}
        <HStack className="w-full justify-between">
          <Frame className="flex items-center gap-2 px-4 py-2 rounded-full bg-white/10 border-0">
             <div className="w-8 h-8 rounded-full bg-green-500" /> {/* Mini thumbnail */}
             <div className="flex flex-col">
               <span className="text-[10px] opacity-50">選択中のシーン</span>
               <span className="text-xs font-bold">自然に注目</span>
             </div>
          </Frame>

          <HStack gap={2}>
             <Frame className="px-4 py-2 rounded-full bg-white/10 border-0 flex items-center gap-2">
               <span className="text-sm">モード</span>
               <Glyph variant="ChevronDown" className="w-4 h-4" />
             </Frame>
             <Button variant="icon" className="w-10 h-10">
               <Glyph variant="FullscreenExit" className="w-5 h-5" />
             </Button>
          </HStack>
        </HStack>

        {/* Slider & Play Action */}
        <HStack className="w-full gap-4">
          <div className="flex-1 relative">
             <Button variant="icon" className="absolute left-0 z-10 w-10 h-10 bg-transparent border border-white/20">
               <Glyph variant="Magic" />
             </Button>
             <Slider className="pl-12 w-full" />
          </div>
          <Button variant="primary" className="w-16 h-16 rounded-full p-0 flex items-center justify-center">
            <Glyph variant="Play" className="w-6 h-6 fill-current" />
          </Button>
        </HStack>
        
      </VStack>
    </div>
  </VStack>
);

export const EditScene = createScene({
  header: { kind: "text", title: "Edit", action: "exit" },
  viewModel: useEditVM,
  view: EditView,
});
TS

# --- PROCESS SCENE ---
cat <<'TS' > src/scenes/Process.scene.tsx
import { createScene } from "./createScene";
import { useProcessVM } from "@/viewmodel/process.vm";
import { VStack } from "@/components/primitives/VStack";
import { Traits } from "@/components/primitives/Traits";
import { Text } from "@/components/primitives/Text";
import { Spinner } from "@/components/primitives/Spinner";
import { Authorship } from "@/components/primitives/Authorship";

// Matches viewport(ProcessingScreen).png
const ProcessView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-center items-center pb-20" gap={12}>
    <Traits active={false} />
    
    <VStack gap={2} className="items-center">
      <Text className="font-mono opacity-70">Initializing Components... 1/10</Text>
      <Spinner size="lg" />
    </VStack>

    <div className="h-8" /> {/* Spacer */}
    
    <Authorship />
  </VStack>
);

export const ProcessScene = createScene({
  header: { kind: "text", title: "", action: "cancel" }, // Button says Cancel
  viewModel: useProcessVM,
  view: ProcessView,
});
TS

# --- RESULT SCENE ---
cat <<'TS' > src/scenes/Result.scene.tsx
import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { Frame } from "@/components/primitives/Frame";
import { Text } from "@/components/primitives/Text";
import { Button } from "@/components/assemblies/Button";
import { HStack } from "@/components/primitives/HStack";

// Matches viewport(ResultScreen).png
const ResultView = ({ vm }: { vm: any }) => (
  <>
    {/* Main Image Content */}
    <VStack className="h-full justify-center pb-40 px-0">
      <div className="w-full aspect-[4/3] bg-zinc-800 relative">
        {/* Placeholder for Final Image */}
        <div className="absolute inset-0 flex items-center justify-center text-white/20 font-bold text-4xl">
          RESULT
        </div>
      </div>
    </VStack>

    {/* Bottom Sheet Card */}
    <div className="absolute bottom-6 left-4 right-4">
      <Frame className="bg-[#333] border-0 p-6 rounded-3xl shadow-2xl">
         <div className="w-12 h-1 bg-black/20 rounded-full mx-auto mb-4" />
         
         <HStack className="justify-between items-start mb-6 px-4">
           <VStack gap={1} className="items-center">
             <Text variant="caption">AIによる画像の評価</Text>
             <Text className="text-4xl font-bold italic">危険度40</Text>
           </VStack>
           <VStack gap={1} className="items-center opacity-50">
             <Text variant="caption">前回の評価</Text>
             <Text className="text-4xl font-bold italic">140</Text>
           </VStack>
         </HStack>
         
         <Text variant="caption" className="text-[10px] text-center mb-4 opacity-50 px-2">
           危険度はAIによる判定で信頼できない場合があります。目安であり個人情報の保護を確実に保証するものではありません。
         </Text>

         <Button variant="primary" className="w-full font-bold">
           画像を保存
         </Button>
      </Frame>
    </div>
  </>
);

export const ResultScene = createScene({
  header: { kind: "text", title: "Result", action: "exit" },
  viewModel: useSceneVM,
  view: ResultView,
});
TS

# ==========================================
# 9. App Entry Points
# ==========================================
echo "🚪 Generating Entry Points..."

cat <<'TS' > src/components/SceneRenderer.tsx
"use client";
import { useAppStore } from "@/store/app.store";
import { HomeScene } from "@/scenes/Home.scene";
import { SelectScene } from "@/scenes/Select.scene";
import { EditScene } from "@/scenes/Edit.scene";
import { ProcessScene } from "@/scenes/Process.scene";
import { ResultScene } from "@/scenes/Result.scene";

export const SceneRenderer = () => {
  const scene = useAppStore((s) => s.scene);
  switch (scene) {
    case "home": return <HomeScene />;
    case "select": return <SelectScene />;
    case "edit": return <EditScene />;
    case "process": return <ProcessScene />;
    case "result": return <ResultScene />;
    default: return <HomeScene />;
  }
};
TS

cat <<'TS' > src/app/page.tsx
import { SceneRenderer } from "@/components/SceneRenderer";
export default function Page() {
  return (
    <main className="w-screen h-screen bg-black">
      <SceneRenderer />
    </main>
  );
}
TS

cat <<'TS' > src/app/layout.tsx
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Aidentify",
  description: "Privacy First AI",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
TS

echo "✅ aidentify v3.0 Setup Complete!"
echo "   - Scenes are implemented to match Viewport images."
echo "   - Primitives and Assemblies are modular."
echo "   - Run 'npm run dev' to see the screens."