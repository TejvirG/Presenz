import User from "../models/User.js";

export const registerFace = async (req, res) => {
  try {
    const { faceData } = req.body;
    if (!faceData) return res.status(400).json({ message: "Face data missing" });

    req.user.faceData = faceData;
    await req.user.save();
    res.json({ message: "Face registered successfully" });
  } catch (e) {
    res.status(500).json({ message: "Error saving face data" });
  }
};

export const verifyFace = async (req, res) => {
  try {
    const { faceData } = req.body;
    if (!faceData) return res.status(400).json({ message: "Face data missing" });

    const match = req.user.faceData === faceData; // simplified comparison
    if (!match) return res.status(401).json({ message: "Face mismatch" });

    res.json({ message: "Face verified successfully" });
  } catch (e) {
    res.status(500).json({ message: "Verification error" });
  }
};