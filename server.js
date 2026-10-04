import express from 'express';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import fs from 'fs';
import nodemailer from 'nodemailer';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
app.use(express.json());
const PORT = 3000;

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: true,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

app.use(express.static(__dirname));

app.get('/api/supabase-config', (req, res) => {
  try {
    const configPath = join(__dirname, 'supabase-config.json');
    let fileConfig = {};
    if (fs.existsSync(configPath)) {
      fileConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    }
    const supabaseUrl = process.env.SUPABASE_URL || fileConfig.supabaseUrl || '';
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || fileConfig.supabaseAnonKey || '';
    res.json({ supabaseUrl, supabaseAnonKey });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read supabase config' });
  }
});

app.post('/api/supabase-config', (req, res) => {
  try {
    const { supabaseUrl, supabaseAnonKey } = req.body;
    const configPath = join(__dirname, 'supabase-config.json');
    const newConfig = {
      supabaseUrl: (supabaseUrl || '').trim(),
      supabaseAnonKey: (supabaseAnonKey || '').trim()
    };
    fs.writeFileSync(configPath, JSON.stringify(newConfig, null, 2), 'utf8');
    res.json({ success: true, ...newConfig });
  } catch (err) {
    res.status(500).json({ error: 'Failed to save supabase config' });
  }
});

app.post('/api/send-email', async (req, res) => {
  const { to, subject, text } = req.body;
  try {
    await transporter.sendMail({ from: process.env.SMTP_USER, to, subject, text });
    res.status(200).json({ success: true });
  } catch (error) {
    console.error('Email error:', error);
    res.status(500).json({ error: 'Failed to send email' });
  }
});

app.get('*', (req, res) => {
  res.sendFile(join(__dirname, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${PORT}`);
});
