import { ReactNode, useEffect } from "react";
import { useSceneStore } from "@/store/scene.store";
import { SurfaceSpec, HeaderSpec } from "@/domain/types";

type AdapterConfig<VM> = {
  viewModel: () => VM;
  view: (props: { vm: VM }) => ReactNode;
  surface?: SurfaceSpec;
  header?: HeaderSpec; // 型エラー回避のため追加（現在は未使用）
};

export function createScene<VM>(config: AdapterConfig<VM>) {
  return function SceneAdapter() {
    const vm = config.viewModel();
    const setSurfaceSpec = useSceneStore((s) => s.setSurfaceSpec);

    // マウント時にsurfaceSpecをzustandに設定
    useEffect(() => {
      if (config.surface) {
        setSurfaceSpec(config.surface);
      }
    }, [config.surface, setSurfaceSpec]);

    return <config.view vm={vm} />;
  };
}
