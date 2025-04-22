
import React from "react";

const Signup = () => (
  <main className="min-h-screen flex flex-col items-center justify-center bg-[var(--main-bg)] py-12">
    <div className="theme-card max-w-md w-full px-6 py-8 mx-2">
      <h2 className="text-2xl font-extrabold text-center mb-2 tracking-tight">Create Your QR</h2>
      <div className="mb-6 text-center text-sm text-[var(--main-fg)] opacity-80">
        Sign up to get started—make authentic connections, then sync up in your unique way.
      </div>
      {/* Simple placeholder for actual form (to be extended) */}
      <form className="flex flex-col gap-4">
        <input className="rounded border px-3 py-2" type="text" placeholder="Name" required />
        <input className="rounded border px-3 py-2" type="email" placeholder="Email" required />
        <button className="theme-btn mt-2" type="submit">
          Sign Up & Create My QR
        </button>
      </form>
      <div className="mt-4 text-xs text-center text-[var(--main-fg)]/60">
        By signing up, you agree to ZYNCUP’s <a href="/terms" className="underline">Terms</a> and <a href="/privacy" className="underline">Privacy Policy</a>.
      </div>
    </div>
  </main>
);

export default Signup;
