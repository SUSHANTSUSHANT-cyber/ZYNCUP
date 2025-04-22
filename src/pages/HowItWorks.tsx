
import React from "react";

const HowItWorks = () => (
  <main className="min-h-screen bg-[var(--main-bg)]">
    <section className="py-16 px-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-3xl font-bold text-center mb-10">How ZYNCUP Works</h2>
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-3">
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Create Profile</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Set up your dating profile with your pictures and interests. Add your orientation for better matching.</p>
          </div>
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Share QR Code</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Show your QR in person—no more awkward handles.</p>
          </div>
          <div className="theme-card p-6 text-center flex flex-col items-center">
            <span className="h-7 w-7 mx-auto mb-3 rounded-full bg-[var(--main-accent)]"></span>
            <div className="font-semibold">Sync Up</div>
            <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Scan and connect to <span className="font-semibold">one</span> partner only. Loyalty ensured!</p>
          </div>
        </div>
        <div className="mt-8 bg-pink-50 border border-pink-200 dark:bg-[#2c181a] dark:border-[#ea384c]/40 rounded-md p-4 text-pink-800 dark:text-[#ea384c] text-center text-xs">
          <b>ZYNCUP</b> keeps it simple and loyal! One connection per user. <br />
          For advanced connection management, please ask support.
        </div>
      </div>
    </section>
  </main>
);

export default HowItWorks;
