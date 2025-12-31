#!/bin/bash
set -e

echo "🛠 Patching aidentify to Strict Architecture (Root Structure)..."

# ==========================================
# 0. Clean up old src/ if exists (Optional safety)
# ==========================================
# rm -rf src  # ※ 既存コードが消えるのが怖い場合はコメントアウトのままにしてください

# ==========================================
# 1. Create Root Directory Structure
# ==========================================
mkdir -p app
mkdir -p components/primitives
mkdir -p components/assemblies
mkdir -p components/layout
mkdir -p scenes
mkdir -p viewmodel
mkdir -p store
mkdir -p motion
mkdir -p domain
mkdir -p infra
mkdir -p lib

# ==========================================
# 2. Utils & Domain
# ==========================================
cat <<'EOF' > lib/utils.ts
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

cat <<'EOF' > domain/types.ts
// Discriminated Unions for State
export type SceneKind = "home" | "select" | "edit" | "process" | "result";
export type Intent = "mask" | "blur" | "pixelate" | "remove" | "auto";
export type EditMode = "crop" | "tune" | "magic";

export type HeaderSpec = 
  | { kind: "logo"; action?: string }
  | { kind: "text"; title: string; action?: string }
  | { kind: "none" };
EOF

# ==========================================
# 3. Store Layer (Exactly as requested)
# ==========================================
echo "💾 Generating Stores..."

cat <<'EOF' > store/scene.store.ts
import { create } from "zustand";
import { SceneKind } from "@/domain/types";

interface SceneState {
  scene: SceneKind;
  setScene: (scene: SceneKind) => void;
}

export const useSceneStore = create<SceneState>((set) => ({
  scene: "home",
  setScene: (scene) => set({ scene }),
}));
EOF

cat <<'EOF' > store/intent.store.ts
import { create } from "zustand";
import { Intent } from "@/domain/types";

interface IntentState {
  selectedIntent: Intent | null;
  setIntent: (intent: Intent) => void;
}

export const useIntentStore = create<IntentState>((set) => ({
  selectedIntent: null,
  setIntent: (intent) => set({ selectedIntent: intent }),
}));
EOF

cat <<'EOF' > store/edit.store.ts
import { create } from "zustand";
import { EditMode } from "@/domain/types";

interface EditState {
  mode: EditMode;
  setMode: (mode: EditMode) => void;
}

export const useEditStore = create<EditState>((set) => ({
  mode: "magic",
  setMode: (mode) => set({ mode }),
}));
EOF

cat <<'EOF' > store/history.store.ts
import { create } from "zustand";

interface HistoryState {
  riskScoreHistory: number[];
  addHistory: (score: number) => void;
}

export const useHistoryStore = create<HistoryState>((set) => ({
  riskScoreHistory: [],
  addHistory: (score) => set((state) => ({ riskScoreHistory: [...state.riskScoreHistory, score] })),
}));
EOF

# ==========================================
# 4. Primitives (Atomic UI)
# ==========================================
echo "🧱 Generating Primitives..."

# Layouts (HStack, VStack, ZStack)
cat <<'EOF' > components/primitives/VStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const VStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-col", gap && `gap-${gap}`, className)} {...props}>{children}</div>
);
EOF

cat <<'EOF' > components/primitives/HStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; gap?: number; as?: any; onClick?: () => void };
export const HStack = ({ children, className, gap = 4, ...props }: Props) => (
  <div className={cn("flex flex-row items-center", gap && `gap-${gap}`, className)} {...props}>{children}</div>
);
EOF

cat <<'EOF' > components/primitives/ZStack.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = { children: ReactNode; className?: string; as?: any };
export const ZStack = ({ children, className, ...props }: Props) => (
  <div className={cn("grid place-items-center > *", className)} {...props}>
    {children}
    <style jsx>{`div > * { grid-area: 1 / 1; width: 100%; height: 100%; }`}</style>
  </div>
);
EOF

cat <<'EOF' > components/primitives/Spacer.tsx
export const Spacer = () => <div className="flex-1" />;
EOF

# Visuals
cat <<'EOF' > components/primitives/Text.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";
export const Text = ({ children, className }: { children: ReactNode; className?: string }) => (
  <p className={cn("text-white/90 font-sans", className)}>{children}</p>
);
EOF

cat <<'EOF' > components/primitives/Glyph.tsx
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
EOF

# Other primitives (Empty shells for brevity but functional)
for comp in Badge Traits Sticker Authorship Tooltip Card Spinner TitleLogo Frame; do
  cat <<EOF > components/primitives/${comp}.tsx
import { cn } from "@/lib/utils";
export const ${comp} = ({ className, children, ...props }: any) => (
  <div className={cn("border border-white/10 p-2 rounded", className)} {...props}>
    ${comp} {children}
  </div>
);
EOF
done

# Fix specific primitives with better mocks
cat <<'EOF' > components/primitives/Spinner.tsx
export const Spinner = ({ className }: { className?: string }) => (
  <div className={`animate-spin w-8 h-8 border-2 border-white/20 border-t-white rounded-full ${className}`} />
);
EOF

# ==========================================
# 5. Assemblies (UI Components with Local State)
# ==========================================
echo "🧩 Generating Assemblies..."

cat <<'EOF' > components/assemblies/Button.tsx
import { ReactNode } from "react";
import { cn } from "@/lib/utils";
export const Button = ({ children, className, onClick }: { children: ReactNode; className?: string; onClick?: () => void }) => (
  <button onClick={onClick} className={cn("flex items-center justify-center bg-white/10 hover:bg-white/20 active:scale-95 transition-all rounded-full h-12 px-6", className)}>
    {children}
  </button>
);
EOF

cat <<'EOF' > components/assemblies/BottomSheet.tsx
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
EOF

# Stubs for other assemblies
for comp in ModeCarouselService IntentService Slider CropOverlay; do
  cat <<EOF > components/assemblies/${comp}.tsx
import { cn } from "@/lib/utils";
export const ${comp} = ({ className }: any) => <div className={cn("bg-white/5 p-4 rounded", className)}>${comp}</div>;
EOF
done

# ==========================================
# 6. ViewModel Layer (Logic)
# ==========================================
echo "🧠 Generating ViewModels..."

cat <<'EOF' > viewmodel/scene.vm.ts
import { useSceneStore } from "@/store/scene.store";
export const useSceneVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  return {
    onLogin: () => setScene("select"),
    onExit: () => setScene("home"),
  };
};
EOF

cat <<'EOF' > viewmodel/intent.vm.ts
import { useSceneStore } from "@/store/scene.store";
import { useIntentStore } from "@/store/intent.store";
export const useIntentVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  const setIntent = useIntentStore((s) => s.setIntent);
  return {
    onSelectIntent: (i: any) => { setIntent(i); setScene("edit"); },
    onExit: () => setScene("home"),
  };
};
EOF

cat <<'EOF' > viewmodel/edit.vm.ts
import { useSceneStore } from "@/store/scene.store";
export const useEditVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  return {
    onPlay: () => setScene("process"),
    onExit: () => setScene("select"),
  };
};
EOF

cat <<'EOF' > viewmodel/process.vm.ts
import { useSceneStore } from "@/store/scene.store";
import { useEffect, useState } from "react";

export const useProcessVM = () => {
  const setScene = useSceneStore((s) => s.setScene);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const timer = setTimeout(() => setScene("result"), 2000);
    return () => clearTimeout(timer);
  }, [setScene]);

  return {
    progress,
    onCancel: () => setScene("edit"),
  };
};
EOF

# ==========================================
# 7. Scene Adapter (createScene HOC)
# ==========================================
echo "🔌 Generating Scene Adapter..."

cat <<'EOF' > scenes/createScene.tsx
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
    // VM must map actions to match header spec actions if needed
    const handleAction = (vm as any).onExit || (vm as any).onCancel || (() => console.log("Action"));

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
EOF

# Layout Components
cat <<'EOF' > components/layout/Surface.tsx
import { ReactNode } from "react";
export const Surface = ({ children }: { children: ReactNode }) => (
  <div className="relative w-full h-screen bg-black text-white overflow-hidden">
    {children}
  </div>
);
EOF

cat <<'EOF' > components/layout/Header.tsx
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
EOF

# ==========================================
# 8. Scenes (The Exact JSX Trees)
# ==========================================
echo "🎬 Generating Scenes with Exact JSX Trees..."

# --- HOME ---
cat <<'EOF' > scenes/Home.scene.tsx
import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { Badge } from "@/components/primitives/Badge";
import { Traits } from "@/components/primitives/Traits";
import { Sticker } from "@/components/primitives/Sticker";
import { Authorship } from "@/components/primitives/Authorship";
import { Button } from "@/components/assemblies/Button";
import { Glyph } from "@/components/primitives/Glyph";

const HomeView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-between p-6">
    <VStack className="flex-1 justify-center items-center">
      <Badge label="v3.0" />
      <Traits active={true} />
      <Sticker />
    </VStack>
    <VStack>
      <Authorship />
      <Button onClick={vm.onLogin} className="w-full">
        <Glyph variant="Upload" className="mr-2" /> Start
      </Button>
    </VStack>
  </VStack>
);

export const HomeScene = createScene({
  header: { kind: "logo", action: "login" },
  viewModel: useSceneVM,
  view: HomeView,
});
EOF

# --- SELECT ---
cat <<'EOF' > scenes/Select.scene.tsx
import { createScene } from "./createScene";
import { useIntentVM } from "@/viewmodel/intent.vm";
import { VStack } from "@/components/primitives/VStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { Tooltip } from "@/components/primitives/Tooltip";
import { IntentService } from "@/components/assemblies/IntentService";
import { ModeCarouselService } from "@/components/assemblies/ModeCarouselService";

const SelectView = ({ vm }: { vm: any }) => (
  <>
    {/* Overlay */}
    <div className="absolute inset-0 z-20 pointer-events-none flex flex-col justify-end">
      <div className="pointer-events-auto">
        <BottomSheet title="Intent" subtitle="12 Intents">
            <VStack>
                <Tooltip text="Select an intent" />
                <IntentService onClick={vm.onSelectIntent} />
            </VStack>
        </BottomSheet>
      </div>
    </div>

    {/* Content */}
    <VStack className="h-full pt-20 px-4">
        <ModeCarouselService />
    </VStack>
  </>
);

export const SelectScene = createScene({
  header: { kind: "text", title: "Select", action: "exit" },
  viewModel: useIntentVM,
  view: SelectView,
});
EOF

# --- EDIT ---
cat <<'EOF' > scenes/Edit.scene.tsx
import { createScene } from "./createScene";
import { useEditVM } from "@/viewmodel/edit.vm";
import { VStack } from "@/components/primitives/VStack";
import { HStack } from "@/components/primitives/HStack";
import { ZStack } from "@/components/primitives/ZStack";
import { Spacer } from "@/components/primitives/Spacer";
import { Text } from "@/components/primitives/Text";
import { CropOverlay } from "@/components/assemblies/CropOverlay";
import { IntentService } from "@/components/assemblies/IntentService";
import { ModeCarouselService } from "@/components/assemblies/ModeCarouselService"; // Assuming distinct from dropdown
import { Slider } from "@/components/assemblies/Slider";
import { Button } from "@/components/assemblies/Button";
import { Glyph } from "@/components/primitives/Glyph";

const EditView = ({ vm }: { vm: any }) => (
  <div className="h-full w-full flex flex-col p-4">
    <VStack className="h-full" gap={4}>
       <Spacer />
       
       <VStack className="flex-1">
          <Text className="text-center opacity-70">Drag to adjust</Text>
          
          <ZStack as="Stage" className="flex-1 bg-zinc-900 rounded-lg overflow-hidden relative">
             <div className="absolute inset-0 bg-gray-800 opacity-50" /> {/* Image Placeholder */}
             <CropOverlay />
          </ZStack>

          <HStack as="Control" className="justify-between">
             <IntentService className="w-1/3" />
             <ModeCarouselService className="w-1/3" />
             <Button className="w-12 h-12 p-0">
               <Glyph variant="FullscreenExit" />
             </Button>
          </HStack>
       </VStack>

       <HStack as="Action" className="pt-4 border-t border-white/10">
          <Slider className="flex-1" />
          <Button onClick={vm.onPlay}>
             <Glyph variant="Play" />
          </Button>
       </HStack>
    </VStack>
  </div>
);

export const EditScene = createScene({
  header: { kind: "text", title: "Edit", action: "exit" },
  viewModel: useEditVM,
  view: EditView,
});
EOF

# --- PROCESS ---
cat <<'EOF' > scenes/Process.scene.tsx
import { createScene } from "./createScene";
import { useProcessVM } from "@/viewmodel/process.vm";
import { VStack } from "@/components/primitives/VStack";
import { Traits } from "@/components/primitives/Traits";
import { Text } from "@/components/primitives/Text";
import { Spinner } from "@/components/primitives/Spinner";
import { Authorship } from "@/components/primitives/Authorship";

const ProcessView = ({ vm }: { vm: any }) => (
  <VStack className="h-full justify-center items-center" gap={8}>
      <Traits active={false} />
      <Text className="animate-pulse">AI is processing... {vm.progress}%</Text>
      <Spinner />
      <Authorship />
  </VStack>
);

export const ProcessScene = createScene({
  header: { kind: "none" },
  viewModel: useProcessVM,
  view: ProcessView,
});
EOF

# --- RESULT ---
cat <<'EOF' > scenes/Result.scene.tsx
import { createScene } from "./createScene";
import { useSceneVM } from "@/viewmodel/scene.vm";
import { VStack } from "@/components/primitives/VStack";
import { BottomSheet } from "@/components/assemblies/BottomSheet";
import { Card } from "@/components/primitives/Card";
import { Text } from "@/components/primitives/Text";

const ResultView = ({ vm }: { vm: any }) => (
  <>
    {/* Overlay */}
    <div className="absolute inset-0 z-20 pointer-events-none flex flex-col justify-end">
        <div className="pointer-events-auto">
           <BottomSheet title="Analysis Result">
               <Card className="p-4 bg-zinc-800">
                  <Text>Privacy Risk: Low</Text>
               </Card>
           </BottomSheet>
        </div>
    </div>

    {/* Content */}
    <VStack className="h-full justify-center items-center p-4">
        <div className="w-full aspect-[4/5] bg-zinc-800 rounded-lg" /> {/* Final Image */}
    </VStack>
  </>
);

export const ResultScene = createScene({
  header: { kind: "text", title: "Result", action: "exit" },
  viewModel: useSceneVM,
  view: ResultView,
});
EOF

# ==========================================
# 9. App Entry (App Router)
# ==========================================
echo "🚪 Generating App Router Entry..."

cat <<'EOF' > components/SceneRenderer.tsx
"use client";
import { useSceneStore } from "@/store/scene.store";
import { HomeScene } from "@/scenes/Home.scene";
import { SelectScene } from "@/scenes/Select.scene";
import { EditScene } from "@/scenes/Edit.scene";
import { ProcessScene } from "@/scenes/Process.scene";
import { ResultScene } from "@/scenes/Result.scene";

export const SceneRenderer = () => {
  const scene = useSceneStore((s) => s.scene);
  
  // Strict matching based on SceneKind
  switch (scene) {
    case "home": return <HomeScene />;
    case "select": return <SelectScene />;
    case "edit": return <EditScene />;
    case "process": return <ProcessScene />;
    case "result": return <ResultScene />;
    default: return null;
  }
};
EOF

# Ensure app/page.tsx uses the renderer
cat <<'EOF' > app/page.tsx
import { SceneRenderer } from "@/components/SceneRenderer";

export default function Page() {
  return (
    <main className="w-screen h-screen overflow-hidden bg-black">
      <SceneRenderer />
    </main>
  );
}
EOF

echo "✅ Patch Complete. Directory structure and JSX trees are aligned with the spec."