import express from 'express';
import db from '../config/db.js';
import jwt from 'jsonwebtoken';

const router = express.Router();

function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}



router.post("/register/send-otp", async (req, res) => {
  try {
    const { phone_number, full_name } = req.body;

    if (!phone_number || !full_name?.trim()) {
      return res.status(400).json({
        success: false,
        message: "full name required for new user"
      });
    }

    
    const userResult = await db.query(
      "SELECT * FROM users_schema.users WHERE phone_number=$1",
      [phone_number]
    );

    if (userResult.rows.length > 0) {
      return res.status(400).json({
        success: false,
        message: "User already exists, please login instead"
      });
    }

    
    await db.query(
      `INSERT INTO users_schema.users (full_name, phone_number, is_verified)
       VALUES ($1, $2, false)`,
      [full_name.trim(), phone_number]
    );

    
    const otp = generateOTP();
    const expires_at = new Date(Date.now() + 5 * 60 * 1000); // 5 min validity

    await db.query(
      `INSERT INTO users_schema.otp_verifications (phone_number, otp_code, expires_at)
       VALUES ($1, $2, $3)`,
      [phone_number, otp, expires_at]
    );

    console.log(`✅ Registration OTP for ${phone_number}: ${otp}`);
    return res.status(200).json({
      success: true,
      message: "OTP sent for registration"
    });
  } catch (error) {
    console.error("Error in /register/send-otp:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
});


router.post("/register/verify-otp", async (req, res) => {
  try {
    const { phone_number, otp } = req.body;

    if (!phone_number || !otp) {
      return res.status(400).json({
        success: false,
        message: "phone_number and otp are required"
      });
    }

  
    const otpResult = await db.query(
      `SELECT * FROM users_schema.otp_verifications
       WHERE phone_number=$1 AND otp_code=$2 AND is_used=false AND expires_at > NOW()
       ORDER BY id DESC LIMIT 1`,
      [phone_number, otp]
    );

    if (otpResult.rows.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired OTP"
      });
    }

    const otpRow = otpResult.rows[0];

    
    await db.query(`UPDATE users_schema.otp_verifications SET is_used=true WHERE id=$1`, [otpRow.id]);

    
    await db.query(
      `UPDATE users_schema.users SET is_verified=true, updated_at=NOW() WHERE phone_number=$1`,
      [phone_number]
    );

    
    const userResult = await db.query(
      `SELECT * FROM users_schema.users WHERE phone_number=$1`,
      [phone_number]
    );
    const user = userResult.rows[0];

    
    const token = jwt.sign(
      { id: user.id, phone_number: user.phone_number, full_name: user.full_name },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    return res.status(200).json({
      success: true,
      message: "Registration completed successfully",
      token,
      user
    });
  } catch (error) {
    console.error("Error in /register/verify-otp:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
});




router.post("/login/send-otp", async (req, res) => {
  try {
    const { phone_number } = req.body;

    if (!phone_number) {
      return res.status(400).json({
        success: false,
        message: "phone_number is required"
      });
    }

    const userResult = await db.query(
      "SELECT * FROM users_schema.users WHERE phone_number=$1",
      [phone_number]
    );

    if (userResult.rows.length === 0) {
      return res.status(400).json({
        success: false,
        message: "User not found, please register first"
      });
    }

    
    const otp = generateOTP();
    const expires_at = new Date(Date.now() + 5 * 60 * 1000);

    await db.query(
      `INSERT INTO users_schema.otp_verifications (phone_number, otp_code, expires_at)
       VALUES ($1, $2, $3)`,
      [phone_number, otp, expires_at]
    );

    console.log(`✅ Login OTP for ${phone_number}: ${otp}`);
    return res.status(200).json({
      success: true,
      message: "OTP sent for login"
    });
  } catch (error) {
    console.error("Error in /login/send-otp:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
});


router.post("/login/verify-otp", async (req, res) => {
  try {
    const { phone_number, otp } = req.body;

    if (!phone_number || !otp) {
      return res.status(400).json({
        success: false,
        message: "phone_number and otp are required"
      });
    }

    const otpResult = await db.query(
      `SELECT * FROM users_schema.otp_verifications
       WHERE phone_number=$1 AND otp_code=$2 AND is_used=false AND expires_at > NOW()
       ORDER BY id DESC LIMIT 1`,
      [phone_number, otp]
    );

    if (otpResult.rows.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired OTP"
      });
    }

    const otpRow = otpResult.rows[0];
    await db.query(`UPDATE users_schema.otp_verifications SET is_used=true WHERE id=$1`, [otpRow.id]);

    const userResult = await db.query(
      `SELECT * FROM users_schema.users WHERE phone_number=$1`,
      [phone_number]
    );

    const user = userResult.rows[0];

    
    if (!user.is_verified) {
      await db.query(`UPDATE users_schema.users SET is_verified=true WHERE id=$1`, [user.id]);
      user.is_verified = true;
    }

    const token = jwt.sign(
      { id: user.id, phone_number: user.phone_number, full_name: user.full_name },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );
   
res.cookie("token", token, {
  httpOnly: true,      
  secure: false,       
 sameSite: "lax",       
  path: "/",    
  maxAge: 30 * 24 * 60 * 60 * 1000, 
});


    return res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user
    });
  } catch (error) {
    console.error("Error in /login/verify-otp:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

export default router;
