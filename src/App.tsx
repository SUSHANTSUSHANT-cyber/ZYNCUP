
import React, { useState, useEffect } from "react";
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Index from "./pages/Index";
import NotFound from "./pages/NotFound";
import Profile from "./pages/Profile";
import Scanner from "./pages/Scanner";
import ThemeToggle from "@/components/ThemeToggle";

// Create a client
const queryClient = new QueryClient();

const App = () => {
  // Theme state: 'love' = off white & pink, 'night' = black & neon red
  const [theme, setTheme] = useState<"love" | "night">(() => {
    if (typeof window !== "undefined") {
      return (localStorage.getItem("theme") as "love" | "night") || "love";
    }
    return "love";
  });

  useEffect(() => {
    if (theme === "night") {
      document.documentElement.classList.add("nightmode");
      document.documentElement.classList.remove("lovemode");
    } else {
      document.documentElement.classList.add("lovemode");
      document.documentElement.classList.remove("nightmode");
    }
    localStorage.setItem("theme", theme);
  }, [theme]);

  return (
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <TooltipProvider>
          <div className="relative">
            <div className="absolute top-4 right-4 z-50">
              <ThemeToggle theme={theme} setTheme={setTheme} />
            </div>
            <Toaster />
            <Sonner />
            <BrowserRouter>
              <Routes>
                <Route path="/" element={<Index />} />
                <Route path="/profile/:id" element={<Profile />} />
                <Route path="/scanner" element={<Scanner />} />
                {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
                <Route path="*" element={<NotFound />} />
              </Routes>
            </BrowserRouter>
          </div>
        </TooltipProvider>
      </QueryClientProvider>
    </React.StrictMode>
  );
};

export default App;
