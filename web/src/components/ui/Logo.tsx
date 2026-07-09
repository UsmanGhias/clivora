"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

interface LogoProps {
  size?: "sm" | "md" | "lg" | "xl";
  showText?: boolean;
  className?: string;
}

const sizes = {
  sm: { img: 36, text: "text-lg", gap: "gap-2.5" },
  md: { img: 44, text: "text-xl", gap: "gap-3" },
  lg: { img: 56, text: "text-2xl", gap: "gap-3" },
  xl: { img: 72, text: "text-3xl", gap: "gap-4" },
};

export function Logo({
  size = "md",
  showText = true,
  className,
}: LogoProps) {
  const s = sizes[size];

  return (
    <div className={cn("flex items-center", s.gap, className)}>
      <motion.div
        whileHover={{ scale: 1.05 }}
        transition={{ type: "spring", stiffness: 400 }}
        className="relative shrink-0 overflow-hidden rounded-xl shadow-lg shadow-primary/20"
        style={{ width: s.img, height: s.img }}
      >
        <Image
          src="/clivora_logo.png"
          alt="CLIVORA logo"
          width={s.img}
          height={s.img}
          className="h-full w-full object-cover"
          priority
        />
      </motion.div>
      {showText && (
        <span
          className={cn(
            "font-extrabold tracking-[0.15em] text-white",
            s.text
          )}
        >
          CLIVORA
        </span>
      )}
    </div>
  );
}
