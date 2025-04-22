
import { Link } from "react-router-dom";
import { QrCode, Heart, MessageCircle, User } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

const Index = () => {
  const { toast } = useToast();

  return (
    <div className="min-h-screen" style={{ background: "var(--main-bg)" }}>
      {/* Hero Section */}
      <header className="theme-hero py-16 px-4 text-center bg-[var(--hero-bg)]">
        <h1 className="text-5xl font-bold mb-4 bg-clip-text text-transparent" style={{ backgroundImage: "linear-gradient(90deg,var(--main-accent),var(--main-fg))" }}>
          Meet IRL.
        </h1>
        <p className="text-xl mb-10 max-w-md mx-auto text-[var(--main-fg)] opacity-80">
          A new way to date—connect in person, then share your profile digitally by QR code.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link to="/scanner" className="sm:w-auto w-full">
            <button className="theme-btn w-full flex items-center justify-center gap-2">
              <QrCode size={18} /> Scan QR
            </button>
          </Link>
          <Link to="/profile/1" className="sm:w-auto w-full">
            <button className="theme-btn-outline w-full flex items-center justify-center gap-2">
              <User size={18} /> Create QR
            </button>
          </Link>
        </div>
      </header>

      {/* How it Works Section */}
      <section className="py-16 px-4 bg-[var(--main-bg)]">
        <div className="max-w-2xl mx-auto">
          <h2 className="text-3xl font-bold text-center mb-10">How It Works</h2>
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-3">
            <div className="theme-card p-6 text-center flex flex-col items-center">
              <User className="h-7 w-7 mx-auto mb-3 text-[var(--main-accent)]" />
              <div className="font-semibold">Create Profile</div>
              <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Set up your dating profile with your pictures and interests.</p>
            </div>
            <div className="theme-card p-6 text-center flex flex-col items-center">
              <QrCode className="h-7 w-7 mx-auto mb-3 text-[var(--main-accent)]" />
              <div className="font-semibold">Share QR Code</div>
              <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Show your QR when you meet someone interesting—no more awkward handles.</p>
            </div>
            <div className="theme-card p-6 text-center flex flex-col items-center">
              <Heart className="h-7 w-7 mx-auto mb-3 text-[var(--main-accent)]" />
              <div className="font-semibold">Connect IRL</div>
              <p className="text-[var(--main-fg)] opacity-80 text-sm mt-2">Scan theirs to instantly view and start chatting.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Featured Profiles Preview */}
      <section className="py-12 px-4">
        <div className="max-w-2xl mx-auto">
          <h2 className="text-3xl font-bold text-center mb-8">Featured Profiles</h2>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            {[1, 2, 3].map((profile) => (
              <div className="theme-card overflow-hidden hover:shadow-lg transition-shadow" key={profile}>
                <div style={{ height: '7rem', background: "var(--main-accent)" }}></div>
                <div className="relative -mt-8 flex flex-col items-center">
                  <div className="bg-white rounded-full border-4 border-white shadow -mt-8 mb-2 w-16 h-16 flex items-center justify-center text-lg font-bold text-pink-600">
                    {profile === 1 ? "JD" : profile === 2 ? "SM" : "AL"}
                  </div>
                  <div className="font-bold mt-1 mb-1">{profile === 1 ? "Jamie, 28" : profile === 2 ? "Sam, 25" : "Alex, 30"}</div>
                  <div className="text-xs opacity-60 mb-2">
                    {profile === 1 ? "Photographer" : profile === 2 ? "Software Engineer" : "Yoga Instructor"}
                  </div>
                </div>
                <div className="px-4 pb-4">
                  <div className="text-sm mb-3">
                    {profile === 1 
                      ? "Love exploring new places and capturing moments with my camera." 
                      : profile === 2 
                        ? "Coffee addict and hiking enthusiast. Let's talk tech or trails!" 
                        : "Mindfulness advocate. Looking for someone to share adventures with."}
                  </div>
                  <div className="flex justify-between gap-2">
                    <button 
                      className="theme-btn flex-1 flex items-center justify-center gap-1"
                      onClick={() => toast({
                        title: "Demo Only",
                        description: "Sign up to connect with real users!",
                      })}
                    >
                      <Heart className="h-4 w-4" />
                      Like
                    </button>
                    <button 
                      className="theme-btn-outline flex-1 flex items-center justify-center gap-1"
                      onClick={() => toast({
                        title: "Demo Only",
                        description: "Sign up to connect with real users!",
                      })}
                    >
                      <MessageCircle className="h-4 w-4" />
                      Message
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="py-10 px-4 bg-[var(--main-accent)] text-center" style={{ color: "var(--main-fg)" }}>
        <h2 className="text-2xl font-bold mb-2">Ready to connect in real life?</h2>
        <p className="mb-5">Share and scan QR codes for modern, meaningful dating.</p>
        <Link to="/profile/1">
          <button className="theme-btn" style={{ minWidth: "150px" }}>
            <User className="inline-block mr-2" /> Create Your QR
          </button>
        </Link>
      </section>

      {/* Footer */}
      <footer className="py-8 px-4 bg-[var(--main-bg)]">
        <div className="max-w-2xl mx-auto text-center opacity-70 text-[var(--main-fg)]">
          <p>© {new Date().getFullYear()} Meet IRL - Date safely, physically, digitally.</p>
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
};

export default Index;
