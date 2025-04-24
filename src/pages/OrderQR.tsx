
import QROrderForm from "@/components/QROrderForm";

const OrderQR = () => {
  return (
    <div className="min-h-screen bg-[var(--main-bg)] py-12 px-4">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold text-center mb-8 text-[var(--main-fg)]">
          Get Your Physical QR Code
        </h1>
        <p className="text-center mb-8 text-[var(--main-fg)] opacity-80">
          Order a custom-designed QR code that matches your style. Each QR code is printed on premium material and shipped directly to you.
        </p>
        <QROrderForm />
      </div>
    </div>
  );
};

export default OrderQR;
