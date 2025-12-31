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
