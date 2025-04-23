
import React, { useState } from "react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Select, SelectContent, SelectGroup, SelectItem, SelectLabel, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";

const Signup = () => {
  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [sexualOrientation, setSexualOrientation] = useState<string>("");
  const [interestedIn, setInterestedIn] = useState<string>("");

  // Demo values for select; in production, expand as needed
  const orientations = [
    "Heterosexual",
    "Homosexual",
    "Bisexual", 
    "Asexual",
    "Pansexual",
    "Queer",
    "Other"
  ];

  const interestsIn = [
    "Men",
    "Women",
    "Everyone",
    "Other"
  ];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation
    if (!name.trim() || !email.trim() || !sexualOrientation || !interestedIn) {
      toast.error("Please fill all required fields");
      return;
    }
    
    // In a real app, this would send data to a backend
    toast.success("Account created successfully!");
    navigate("/profile/1");
  };

  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-[var(--main-bg)] py-12">
      <div className="theme-card max-w-md w-full px-6 py-8 mx-2">
        <h2 className="text-2xl font-extrabold text-center mb-2 tracking-tight">Create Your QR</h2>
        <div className="mb-6 text-center text-sm text-[var(--main-fg)] opacity-80">
          Sign up to get started—connect in real through real ways and sync up with your perfect match.
        </div>
        
        <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
          <div className="space-y-2">
            <Label htmlFor="name">Name</Label>
            <Input 
              id="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Your name"
              required
            />
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input 
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Your email"
              required
            />
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="orientation">Sexual Orientation</Label>
            <Select value={sexualOrientation} onValueChange={setSexualOrientation} required>
              <SelectTrigger id="orientation">
                <SelectValue placeholder="Select your orientation" />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectLabel>Sexual Orientation</SelectLabel>
                  {orientations.map(o => (
                    <SelectItem key={o} value={o}>{o}</SelectItem>
                  ))}
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="interested">Interested In</Label>
            <Select value={interestedIn} onValueChange={setInterestedIn} required>
              <SelectTrigger id="interested">
                <SelectValue placeholder="I am interested in" />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectLabel>Interested In</SelectLabel>
                  {interestsIn.map(i => (
                    <SelectItem key={i} value={i}>{i}</SelectItem>
                  ))}
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
          
          <div className="mt-2 p-3 rounded-md bg-[var(--main-accent)]/20 text-[var(--main-fg)] text-xs text-center border border-[var(--main-accent)]/40">
            <span className="font-semibold">Note:</span> You can connect to <b>one</b> partner only. Loyalty ensured. <br />
            (This rule is enforced at sign up and connection.)
          </div>
          
          <button className="theme-btn mt-2" type="submit">
            Sign Up & Create My QR
          </button>
        </form>
        
        <div className="mt-4 text-xs text-center text-[var(--main-fg)]/60">
          By signing up, you agree to ZYNCUP's <a href="/terms" className="underline">Terms</a> and <a href="/privacy" className="underline">Privacy Policy</a>.
        </div>
      </div>
    </main>
  );
};

export default Signup;
