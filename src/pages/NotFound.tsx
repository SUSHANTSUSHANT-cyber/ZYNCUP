
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";

const NotFound = () => {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-purple-50 to-pink-50">
      <div className="text-center px-6">
        <h1 className="text-4xl font-bold mb-4 text-purple-600">Page Not Found</h1>
        <p className="text-xl text-gray-600 mb-8">The page you're looking for doesn't exist or has been moved.</p>
        <Button className="bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600">
          <Link to="/">Return Home</Link>
        </Button>
      </div>
    </div>
  );
};

export default NotFound;
