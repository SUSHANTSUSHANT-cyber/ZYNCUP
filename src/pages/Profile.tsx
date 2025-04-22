
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Heart, MessageCircle, QrCode } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";

const Profile = () => {
  const { toast } = useToast();
  
  // This would come from a database in a real implementation
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
    <div className="min-h-screen bg-gradient-to-b from-purple-50 to-pink-50 pt-6 px-4">
      <Card className="max-w-md mx-auto overflow-hidden">
        <div className="h-48 bg-gradient-to-tr from-purple-400 to-pink-300"></div>
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
                  className="px-3 py-1 bg-purple-100 text-purple-600 rounded-full text-sm"
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
        </CardContent>
        
        <CardFooter className="flex justify-between gap-4">
          <Button 
            className="flex-1 bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600"
            onClick={() => toast({
              title: "Liked!",
              description: "You've liked this profile",
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
      
      <div className="max-w-md mx-auto mt-6 flex">
        <Button 
          variant="secondary" 
          className="flex-1"
          onClick={() => toast({
            title: "Chat Feature",
            description: "Chat functionality will be available soon!",
          })}
        >
          <MessageCircle className="h-4 w-4 mr-2" />
          Message
        </Button>
      </div>
    </div>
  );
};

export default Profile;
