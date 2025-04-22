
import React from "react";
import { Heart, MessageCircle } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

const featured = [
  {
    initials: "JD",
    name: "Jamie, 28",
    job: "Photographer",
    about: "Love exploring new places and capturing moments with my camera.",
  },
  {
    initials: "SM",
    name: "Sam, 25",
    job: "Software Engineer",
    about: "Coffee addict and hiking enthusiast. Let's talk tech or trails!",
  },
  {
    initials: "AL",
    name: "Alex, 30",
    job: "Yoga Instructor",
    about: "Mindfulness advocate. Looking for someone to share adventures with.",
  },
];

const Profiles = () => {
  const { toast } = useToast();
  return (
    <main className="min-h-screen bg-[var(--main-bg)] py-12 px-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-3xl font-bold text-center mb-8">Featured Profiles</h2>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {featured.map((profile) => (
            <div className="theme-card overflow-hidden hover:shadow-lg transition-shadow" key={profile.name}>
              <div style={{ height: '7rem', background: "var(--main-accent)" }}></div>
              <div className="relative -mt-8 flex flex-col items-center">
                <div className="bg-white rounded-full border-4 border-white shadow -mt-8 mb-2 w-16 h-16 flex items-center justify-center text-lg font-bold text-pink-600">
                  {profile.initials}
                </div>
                <div className="font-bold mt-1 mb-1">{profile.name}</div>
                <div className="text-xs opacity-60 mb-2">{profile.job}</div>
              </div>
              <div className="px-4 pb-4">
                <div className="text-sm mb-3">{profile.about}</div>
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
    </main>
  );
};
export default Profiles;
