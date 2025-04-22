
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Link } from "react-router-dom";
import { QrCode, Heart, MessageCircle, User } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

const Index = () => {
  const { toast } = useToast();

  return (
    <div className="min-h-screen bg-gradient-to-b from-purple-50 to-pink-50">
      {/* Hero Section */}
      <header className="py-16 px-6 text-center">
        <h1 className="text-5xl font-bold mb-4 bg-clip-text text-transparent bg-gradient-to-r from-purple-600 to-pink-500">
          Meet IRL
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-md mx-auto">
          Connect with people in real life through QR code sharing - dating that starts face-to-face
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button size="lg" className="bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600">
            <Link to="/signup" className="flex items-center gap-2">
              <User size={18} /> Sign Up
            </Link>
          </Button>
          <Button size="lg" variant="outline" className="border-purple-300 text-purple-700">
            <Link to="/login" className="flex items-center gap-2">
              Login
            </Link>
          </Button>
        </div>
      </header>

      {/* How it Works Section */}
      <section className="py-16 px-6 bg-white">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">How It Works</h2>
          <div className="grid md:grid-cols-3 gap-8">
            <Card className="border-purple-100">
              <CardHeader>
                <CardTitle className="text-purple-600 flex items-center gap-2">
                  <User className="h-5 w-5" /> Create Profile
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600">Sign up and create your dating profile with photos and interests</p>
              </CardContent>
            </Card>
            
            <Card className="border-purple-100">
              <CardHeader>
                <CardTitle className="text-purple-600 flex items-center gap-2">
                  <QrCode className="h-5 w-5" /> Share QR Code
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600">When you meet someone interesting, share your unique QR code</p>
              </CardContent>
            </Card>
            
            <Card className="border-purple-100">
              <CardHeader>
                <CardTitle className="text-purple-600 flex items-center gap-2">
                  <Heart className="h-5 w-5" /> Connect & Chat
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600">Scan their QR code to view their profile and start chatting</p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Featured Profiles Preview */}
      <section className="py-16 px-6">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">Featured Profiles</h2>
          <div className="grid md:grid-cols-3 gap-6">
            {[1, 2, 3].map((profile) => (
              <Card key={profile} className="overflow-hidden hover:shadow-lg transition-shadow">
                <div className="h-48 bg-gradient-to-tr from-purple-400 to-pink-300"></div>
                <CardHeader className="relative">
                  <Avatar className="absolute -top-12 left-1/2 transform -translate-x-1/2 h-24 w-24 border-4 border-white">
                    <AvatarFallback>
                      {profile === 1 ? "JD" : profile === 2 ? "SM" : "AL"}
                    </AvatarFallback>
                  </Avatar>
                  <div className="pt-14">
                    <CardTitle>
                      {profile === 1 ? "Jamie, 28" : profile === 2 ? "Sam, 25" : "Alex, 30"}
                    </CardTitle>
                    <CardDescription>
                      {profile === 1 ? "Photographer" : profile === 2 ? "Software Engineer" : "Yoga Instructor"}
                    </CardDescription>
                  </div>
                </CardHeader>
                <CardContent className="text-gray-600">
                  <p>
                    {profile === 1 
                      ? "Love exploring new places and capturing moments with my camera." 
                      : profile === 2 
                        ? "Coffee addict and hiking enthusiast. Let's talk tech or trails!" 
                        : "Mindfulness advocate. Looking for someone to share adventures with."}
                  </p>
                </CardContent>
                <CardFooter className="flex justify-between">
                  <Button 
                    variant="secondary" 
                    className="text-purple-600"
                    onClick={() => toast({
                      title: "Demo Only",
                      description: "Sign up to connect with real users!",
                    })}
                  >
                    <Heart className="h-4 w-4 mr-2" />
                    Like
                  </Button>
                  <Button 
                    variant="outline"
                    className="border-purple-300"
                    onClick={() => toast({
                      title: "Demo Only",
                      description: "Sign up to connect with real users!",
                    })}
                  >
                    <MessageCircle className="h-4 w-4 mr-2" />
                    Message
                  </Button>
                </CardFooter>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="py-16 px-6 bg-gradient-to-r from-purple-600 to-pink-500 text-white text-center">
        <h2 className="text-3xl font-bold mb-4">Ready to meet someone special?</h2>
        <p className="mb-8 max-w-md mx-auto">Create your profile and start connecting in real life today!</p>
        <Button size="lg" variant="secondary" className="bg-white text-purple-600 hover:bg-gray-100">
          <Link to="/signup">Get Started</Link>
        </Button>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 bg-gray-50">
        <div className="max-w-6xl mx-auto text-center text-gray-500">
          <p>© {new Date().getFullYear()} Meet IRL - Connect through QR codes</p>
          <div className="mt-4 flex justify-center gap-4">
            <Link to="/about" className="hover:text-purple-600">About</Link>
            <Link to="/privacy" className="hover:text-purple-600">Privacy Policy</Link>
            <Link to="/terms" className="hover:text-purple-600">Terms of Service</Link>
            <Link to="/contact" className="hover:text-purple-600">Contact</Link>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
