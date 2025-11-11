import dotenv from 'dotenv';
dotenv.config({ path: './.env' });




import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT) || 5432,
  user: process.env.DB_USER,  // ✅ REQUIRED
  password: String(process.env.DB_PASSWORD), // ensure it's a string
  database: process.env.DB_NAME,
  ssl: false,
});

export default {
  query: (text, params) => pool.query(text, params),
  pool
};
