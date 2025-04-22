
import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";

const Profiles = () => {
  const navigate = useNavigate();
  useEffect(() => {
    // Immediately redirect to signup
    navigate("/signup", { replace: true });
  }, [navigate]);
  return null;
};

export default Profiles;
