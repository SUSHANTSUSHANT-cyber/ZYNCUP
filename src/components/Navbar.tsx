
import React from "react";
import { Link } from "react-router-dom";

const Navbar = () => (
  <nav className="w-full flex flex-col sm:flex-row justify-center items-center gap-1 sm:gap-4 py-2 px-2 bg-white/70 dark:bg-black/60 fixed top-0 left-0 z-40 shadow-md border-b border-[var(--main-accent)] sm:static sm:rounded-xl sm:w-auto sm:mx-auto sm:mt-4">
    <div className="flex items-center gap-2">
      <span className="font-extrabold text-xl text-[var(--main-fg)] tracking-tight">ZYNCUP</span>
      <span className="text-xs sm:text-sm opacity-80 text-[var(--main-fg)] italic whitespace-nowrap pl-1">scan to sync</span>
    </div>
    <div className="flex gap-2 flex-wrap mt-1 sm:mt-0 sm:ml-6">
      <Link to="/" className="font-bold text-[var(--main-fg)] hover:underline">Home</Link>
      <Link to="/how-it-works" className="text-[var(--main-fg)] hover:underline">How it Works</Link>
      <Link to="/profiles" className="text-[var(--main-fg)] hover:underline">Profiles</Link>
      <Link to="/scanner" className="text-[var(--main-fg)] hover:underline">Scan QR</Link>
    </div>
  </nav>
);

export default Navbar;
