
import { Link } from "react-router-dom";
import { User } from "lucide-react";
import Navbar from "@/components/Navbar";

const Index = () => (
  <div className="min-h-screen bg-[var(--main-bg)] pb-8">
    <Navbar />
    {/* Hero Section */}
    <header className="theme-hero py-16 px-4 text-center bg-[var(--hero-bg)] mt-10 sm:mt-0">
      <h1 className="text-5xl font-extrabold mb-4 bg-clip-text text-transparent" style={{ backgroundImage: "linear-gradient(90deg,var(--main-accent),var(--main-fg))" }}>
        ZYNCUP
      </h1>
      <div className="text-xl mb-2 max-w-md mx-auto text-[var(--main-fg)] font-semibold tracking-tight">scan to sync</div>
      <p className="text-xl mb-10 max-w-md mx-auto text-[var(--main-fg)] opacity-80">
        Connect in real life—through real moments, then sync up digitally by scanning your unique QR.<br />
        <span className="font-medium text-pink-600">One connection at a time. Loyalty ensured.</span>
      </p>
      <div className="flex flex-col sm:flex-row gap-4 justify-center">
        <Link to="/scanner" className="sm:w-auto w-full">
          <button className="theme-btn w-full flex items-center justify-center gap-2">
            <span className="inline-block w-4 h-4 rounded-full bg-[var(--main-fg)]" /> Scan QR
          </button>
        </Link>
        <Link to="/signup" className="sm:w-auto w-full">
          <button className="theme-btn-outline w-full flex items-center justify-center gap-2">
            <User size={18} /> Create QR
          </button>
        </Link>
      </div>
    </header>
    {/* Call to Action */}
    <section className="py-10 px-4 bg-[var(--main-accent)] text-center" style={{ color: "var(--main-fg)" }}>
      <h2 className="text-2xl font-bold mb-2">Ready to connect in real life?</h2>
      <p className="mb-5">Share and scan QR codes for modern, meaningful dating.</p>
      <Link to="/signup">
        <button className="theme-btn" style={{ minWidth: "150px" }}>
          <User className="inline-block mr-2" /> Create Your QR
        </button>
      </Link>
    </section>
    {/* Footer */}
    <footer className="py-8 px-4 bg-[var(--main-bg)]">
      <div className="max-w-2xl mx-auto text-center opacity-70 text-[var(--main-fg)]">
        <p>© {new Date().getFullYear()} ZYNCUP - Date safely, physically, digitally.</p>
        <div className="mt-2 flex justify-center gap-4 text-sm">
          <Link to="/about" className="hover:underline">About</Link>
          <Link to="/privacy" className="hover:underline">Privacy Policy</Link>
          <Link to="/terms" className="hover:underline">Terms</Link>
          <Link to="/contact" className="hover:underline">Contact</Link>
        </div>
      </div>
    </footer>
  </div>
);
export default Index;
