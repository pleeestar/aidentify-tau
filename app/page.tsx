import { SceneRenderer } from "@/components/SceneRenderer";

export default function Page() {
  return (
    <main className="w-screen h-screen overflow-hidden bg-black">
      <SceneRenderer />
    </main>
  );
}
