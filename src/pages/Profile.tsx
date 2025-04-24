import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Heart, MessageCircle, QrCode } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { Select, SelectGroup, SelectValue, SelectTrigger, SelectContent, SelectItem, SelectLabel } from "@/components/ui/select";
import React, { useState } from "react";
import { Link } from "react-router-dom";

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

const Profile = () => {
  const { toast } = useToast();

  // State for new fields (would use backend in real app)
  const [sexualOrientation, setSexualOrientation] = useState<string>("");
  const [interestedIn, setInterestedIn] = useState<string>("");

  const profile = {
    id: "1",
    name: "Alex",
    age: 28,
    profession: "Designer",
    bio: "Creative mind with a passion for art and design. Love hiking, photography, and trying new restaurants.",
    interests: ["Art", "Hiking", "Photography", "Food", "Travel"],
    photos: ["/placeholder.svg", "/placeholder.svg", "/placeholder.svg"]
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-pink-50 to-pink-100 dark:from-[#111] dark:to-[#222] pt-6 px-4">
      <Card className="max-w-md mx-auto overflow-hidden">
        <div className="h-48 bg-gradient-to-tr from-pink-300 to-pink-100 dark:from-[#ea384c] dark:to-[#191919]"></div>
        <CardHeader className="relative">
          <Avatar className="absolute -top-12 left-1/2 transform -translate-x-1/2 h-24 w-24 border-4 border-white">
            <AvatarImage src="/placeholder.svg" />
            <AvatarFallback>{profile.name.slice(0, 2).toUpperCase()}</AvatarFallback>
          </Avatar>
          <div className="pt-14 text-center">
            <CardTitle className="text-2xl">{profile.name}, {profile.age}</CardTitle>
            <p className="text-gray-500">{profile.profession}</p>
          </div>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* New fields for orientation and interested in */}
          <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
            <div>
              <Select value={sexualOrientation} onValueChange={setSexualOrientation}>
                <SelectTrigger>
                  <SelectValue placeholder="Sexual orientation" />
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
            <div>
              <Select value={interestedIn} onValueChange={setInterestedIn}>
                <SelectTrigger>
                  <SelectValue placeholder="Interested in" />
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
          </div>
          <div>
            <h3 className="font-medium text-lg">About</h3>
            <p className="text-gray-600">{profile.bio}</p>
          </div>

          <div>
            <h3 className="font-medium text-lg">Interests</h3>
            <div className="flex flex-wrap gap-2 mt-2">
              {profile.interests.map((interest, index) => (
                <span 
                  key={index} 
                  className="px-3 py-1 bg-pink-100 text-pink-600 rounded-full text-sm"
                >
                  {interest}
                </span>
              ))}
            </div>
          </div>

          <div>
            <h3 className="font-medium text-lg">Photos</h3>
            <div className="grid grid-cols-3 gap-2 mt-2">
              {profile.photos.map((photo, index) => (
                <div key={index} className="aspect-square bg-gray-100 rounded-md overflow-hidden">
                  <img src={photo} alt="User photo" className="w-full h-full object-cover" />
                </div>
              ))}
            </div>
          </div>
          
          <div className="mt-2 p-3 rounded-md bg-pink-50 text-pink-800 text-xs text-center border border-pink-200 dark:bg-[#2c181a] dark:border-[#ea384c]/40 dark:text-[#ea384c]">
            <span className="font-semibold">Note:</span> You can connect to <b>one</b> partner only. Loyalty ensured. <br />
            (This rule is enforced at sign up and connection – ask admin for support if you get stuck.)
          </div>
        </CardContent>
        <CardFooter className="flex justify-between gap-4">
          <Button 
            className="flex-1 bg-gradient-to-r from-pink-600 to-pink-400 hover:from-pink-700 hover:to-pink-500"
            onClick={() => toast({
              title: "Liked!",
              description: "You've liked this profile",
              duration: 2500
            })}
          >
            <Heart className="h-4 w-4 mr-2" />
            Like Profile
          </Button>
          
          <Sheet>
            <SheetTrigger asChild>
              <Button variant="outline" className="flex-1">
                <QrCode className="h-4 w-4 mr-2" />
                My QR Code
              </Button>
            </SheetTrigger>
            <SheetContent>
              <SheetHeader>
                <SheetTitle>Share Your Profile</SheetTitle>
              </SheetHeader>
              <div className="flex flex-col items-center justify-center py-8">
                <div className="border-4 border-white bg-white p-2 rounded-lg shadow-lg">
                  <img 
                    src="/placeholder.svg"
                    alt="QR Code" 
                    className="w-64 h-64"
                  />
                </div>
                <p className="mt-4 text-gray-600 text-center">
                  Have someone scan this QR code to view your profile
                </p>
              </div>
            </SheetContent>
          </Sheet>
        </CardFooter>
      </Card>
      
      <div className="max-w-md mx-auto mt-6 flex gap-4">
        <Button 
          variant="secondary" 
          className="flex-1"
          onClick={() => toast({
            title: "Chat Feature",
            description: "Chat functionality will be available soon!",
            duration: 2500
          })}
        >
          <MessageCircle className="h-4 w-4 mr-2" />
          Message
        </Button>
        
        <Link to="/order-qr" className="flex-1">
          <Button className="w-full theme-btn">
            <QrCode className="h-4 w-4 mr-2" />
            Get Physical QR
          </Button>
        </Link>
      </div>
    </div>
  );
};

export default Profile;
