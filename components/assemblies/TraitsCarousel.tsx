import { AnimatePresence, motion } from "framer-motion";
import { verticalCycle } from "@/motion/variants";
import * as React from "react";
import { Trait } from "@/components/primitives/";

type TraitsCarouselProps = {
  items: TraitItem[];
  interval?: number;
};

export const TraitsCarousel = ({
  items,
  interval = 2500,
}: TraitsCarouselProps) => {
  const [index, setIndex] = React.useState(0);

  React.useEffect(() => {
    const timer = setInterval(() => {
      setIndex((i) => (i + 1) % items.length);
    }, interval);
    return () => clearInterval(timer);
  }, [items.length, interval]);

  const item = items[index];

  return (
    <div className="relative h-[72px] overflow-hidden">
      <AnimatePresence mode="popLayout">
        <motion.div
          key={item.id}
          variants={verticalCycle}
          initial="enter"
          animate="center"
          exit="exit"
          transition={{ duration: 0.35, ease: "easeOut" }}
        >
          <Trait {...item} />
        </motion.div>
      </AnimatePresence>
    </div>
  );
};
