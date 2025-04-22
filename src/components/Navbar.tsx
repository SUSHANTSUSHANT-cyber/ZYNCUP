
import React from "react";
import { Link } from "react-router-dom";

const Navbar = () => (
  <nav className="w-full flex justify-center gap-4 py-2 px-2 bg-white/70 dark:bg-black/60 fixed top-0 left-0 z-40 shadow-md border-b border-[var(--main-accent)] sm:static sm:rounded-xl sm:w-auto sm:mx-auto sm:mt-4">
    <Link to="/" className="font-bold text-[var(--main-fg)] hover:underline">Home</Link>
    <Link to="/how-it-works" className="text-[var(--main-fg)] hover:underline">How it Works</Link>
    <Link to="/profiles" className="text-[var(--main-fg)] hover:underline">Profiles</Link>
    <Link to="/scanner" className="text-[var(--main-fg)] hover:underline">Scan QR</Link>
  </nav>
);

export default Navbar;
