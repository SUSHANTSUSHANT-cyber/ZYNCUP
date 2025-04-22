
import React from "react";

const HowItWorks = () => (
  <main className="min-h-screen bg-[var(--main-bg)]">
    <section className="py-16 px-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-3xl font-bold text-center mb-10">How It Works</h2>
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-3">
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Create Profile</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Set up your dating profile with your pictures and interests.</p>
          </div>
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Share QR Code</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Show your QR in person—no more awkward handles.</p>
          </div>
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Connect IRL</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Scan theirs to instantly view and start chatting.</p>
          </div>
        </div>
      </div>
    </section>
  </main>
);

export default HowItWorks;
