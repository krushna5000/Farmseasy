import express from 'express';
const router = express.Router();
import authController from '../controllers/authController.js';
import db from '../config/db.js';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config({ path: '../../.env' });

const OTP_TTL_MINUTES = parseInt(process.env.OTP_TTL_MINUTES || '5', 10);


function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}


router.use('/', authController);

export default router;

