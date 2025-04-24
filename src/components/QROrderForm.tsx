
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const QROrderForm = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    address: '',
    city: '',
    state: '',
    zipCode: '',
    country: '',
    theme: 'default'
  });

  const themes = [
    { id: 'default', name: 'Classic Black & White' },
    { id: 'love', name: 'Love Theme' },
    { id: 'night', name: 'Night Mode' },
    { id: 'custom', name: 'Custom Design' }
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        toast.error("Please sign in to place an order");
        navigate("/signup");
        return;
      }

      // First create a QR code entry
      const { data: qrCode, error: qrError } = await supabase
        .from('qr_codes')
        .insert([{
          user_id: user.id,
          qr_url: `https://api.qrserver.com/v1/create-qr-code/?data=${user.id}&size=300x300`,
          theme: formData.theme
        }])
        .select()
        .single();

      if (qrError) throw qrError;

      // Then create the order
      const { error: orderError } = await supabase
        .from('qr_orders')
        .insert([{
          user_id: user.id,
          qr_code_id: qrCode.id,
          address: formData.address,
          city: formData.city,
          state: formData.state,
          zip_code: formData.zipCode,
          country: formData.country,
          theme: formData.theme,
          payment_amount: 29.99 // Example fixed price
        }]);

      if (orderError) throw orderError;

      toast.success("Order placed successfully!");
      navigate("/profile/" + user.id);
    } catch (error) {
      toast.error("Failed to place order. Please try again.");
      console.error('Order error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="max-w-md mx-auto theme-card">
      <CardHeader>
        <CardTitle className="text-center">Order Your Custom QR Code</CardTitle>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="theme">Choose Theme</Label>
            <Select
              value={formData.theme}
              onValueChange={(value) => setFormData(prev => ({ ...prev, theme: value }))}
            >
              <SelectTrigger>
                <SelectValue placeholder="Select a theme" />
              </SelectTrigger>
              <SelectContent>
                {themes.map((theme) => (
                  <SelectItem key={theme.id} value={theme.id}>
                    {theme.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-2">
            <Label htmlFor="address">Shipping Address</Label>
            <Input
              id="address"
              value={formData.address}
              onChange={(e) => setFormData(prev => ({ ...prev, address: e.target.value }))}
              placeholder="Street Address"
              required
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="city">City</Label>
              <Input
                id="city"
                value={formData.city}
                onChange={(e) => setFormData(prev => ({ ...prev, city: e.target.value }))}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="state">State</Label>
              <Input
                id="state"
                value={formData.state}
                onChange={(e) => setFormData(prev => ({ ...prev, state: e.target.value }))}
                required
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="zipCode">ZIP Code</Label>
              <Input
                id="zipCode"
                value={formData.zipCode}
                onChange={(e) => setFormData(prev => ({ ...prev, zipCode: e.target.value }))}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="country">Country</Label>
              <Input
                id="country"
                value={formData.country}
                onChange={(e) => setFormData(prev => ({ ...prev, country: e.target.value }))}
                required
              />
            </div>
          </div>

          <button
            type="submit"
            className="theme-btn w-full"
            disabled={loading}
          >
            {loading ? 'Processing...' : 'Place Order - $29.99'}
          </button>
        </form>
      </CardContent>
    </Card>
  );
};

export default QROrderForm;
