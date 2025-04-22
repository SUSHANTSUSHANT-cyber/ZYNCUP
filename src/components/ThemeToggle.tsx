
import React from "react";
import { ToggleLeft, ToggleRight } from "lucide-react";

type ThemeType = "love" | "night";

interface Props {
  theme: ThemeType;
  setTheme: (theme: ThemeType) => void;
}

const ThemeToggle: React.FC<Props> = ({ theme, setTheme }) => {
  return (
    <button
      className="flex items-center gap-2 px-3 py-2 rounded-full border bg-white/60 dark:bg-black/60 shadow hover:scale-105 transition-transform"
      title="Toggle theme"
      aria-label="Toggle theme"
      onClick={() => setTheme(theme === "love" ? "night" : "love")}
    >
      {theme === "love" ? (
        <>
          <ToggleLeft className="text-pink-400" />
          <span className="text-sm font-semibold text-pink-600">Love</span>
        </>
      ) : (
        <>
          <ToggleRight className="text-red-500" />
          <span className="text-sm font-semibold text-red-500">Night</span>
        </>
      )}
    </button>
  );
};

export default ThemeToggle;
