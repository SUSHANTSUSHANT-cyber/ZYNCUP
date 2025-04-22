
import { useState } from 'react';
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Camera } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { useNavigate } from 'react-router-dom';

const Scanner = () => {
  const { toast } = useToast();
  const navigate = useNavigate();
  const [scanning, setScanning] = useState(false);
  
  const handleScan = () => {
    setScanning(true);
    
    // In a real implementation, we would use a camera API to scan QR codes
    // For now, we'll simulate a scan after a timeout
    setTimeout(() => {
      setScanning(false);
      toast({
        title: "QR Code Scanned!",
        description: "Successfully scanned profile QR code",
      });
      // Navigate to the scanned profile
      navigate('/profile/1');
    }, 3000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-purple-50 to-pink-50 pt-6 px-4">
      <Card className="max-w-md mx-auto">
        <CardHeader>
          <CardTitle className="text-center text-xl text-purple-600">
            Scan a QR Code
          </CardTitle>
        </CardHeader>
        <CardContent className="flex flex-col items-center">
          <div className="relative w-64 h-64 bg-gray-100 rounded-lg mb-6 flex items-center justify-center">
            {scanning ? (
              <>
                <div className="absolute inset-0 border-2 border-purple-500 rounded-lg animate-pulse"></div>
                <Camera className="h-16 w-16 text-purple-300 animate-pulse" />
                <div className="absolute bottom-4 left-0 right-0 text-center text-purple-600">
                  Scanning...
                </div>
              </>
            ) : (
              <>
                <Camera className="h-16 w-16 text-gray-300" />
                <div className="absolute bottom-4 left-0 right-0 text-center text-gray-500">
                  Camera preview will appear here
                </div>
              </>
            )}
          </div>
          
          <p className="text-center text-gray-600 mb-6">
            Position the QR code within the frame to scan
          </p>
          
          <Button 
            className="w-full bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600"
            disabled={scanning}
            onClick={handleScan}
          >
            <Camera className="h-4 w-4 mr-2" />
            {scanning ? "Scanning..." : "Start Scanning"}
          </Button>
        </CardContent>
      </Card>
    </div>
  );
};

export default Scanner;
