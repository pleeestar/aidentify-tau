import { ReactNode } from "react";
export const Surface = ({ children }: { children: ReactNode }) => (
  <div className="relative w-full h-screen bg-black text-white overflow-hidden">
    {children}
  </div>
);
