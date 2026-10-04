-- Supabase SQL Schema for Sneho Nir Mess Management
-- Run this script in your Supabase project: Dashboard -> SQL Editor -> New query -> Run

-- 1. Mess Data Table (Monthly records, accounts, stores, fixed costs)
CREATE TABLE IF NOT EXISTS public.mess_data (
  id TEXT PRIMARY KEY,
  data JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Notices Table
CREATE TABLE IF NOT EXISTS public.notices (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  date TEXT,
  author TEXT,
  author_email TEXT,
  created_at BIGINT DEFAULT (extract(epoch from now()) * 1000)::bigint
);

-- 3. Polls Table
CREATE TABLE IF NOT EXISTS public.polls (
  id TEXT PRIMARY KEY,
  question TEXT NOT NULL,
  options JSONB DEFAULT '[]'::jsonb,
  votes JSONB DEFAULT '{}'::jsonb,
  author TEXT,
  author_email TEXT,
  created_at BIGINT DEFAULT (extract(epoch from now()) * 1000)::bigint
);

-- 4. User Profiles Table
CREATE TABLE IF NOT EXISTS public.user_profiles (
  username TEXT PRIMARY KEY,
  phone TEXT,
  room TEXT,
  role TEXT DEFAULT 'Member',
  email TEXT
);

-- 5. Daily Meals Table
CREATE TABLE IF NOT EXISTS public.daily_meals (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  date TEXT NOT NULL,
  bf NUMERIC DEFAULT 0,
  lunch NUMERIC DEFAULT 0,
  dinner NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0
);

-- 6. Bazar History Table
CREATE TABLE IF NOT EXISTS public.bazar_history (
  id TEXT PRIMARY KEY,
  date TEXT NOT NULL,
  amount NUMERIC DEFAULT 0,
  info TEXT,
  payer TEXT
);

-- 7. Store Records Table
CREATE TABLE IF NOT EXISTS public.store_records (
  id TEXT PRIMARY KEY,
  store_name TEXT NOT NULL,
  amount NUMERIC DEFAULT 0,
  type TEXT,
  date TEXT
);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE public.mess_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bazar_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_records ENABLE ROW LEVEL SECURITY;

-- Allow public read and write access for application operations (Anon Key)
CREATE POLICY "Allow public read-write for mess_data" ON public.mess_data FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for notices" ON public.notices FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for polls" ON public.polls FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for user_profiles" ON public.user_profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for daily_meals" ON public.daily_meals FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for bazar_history" ON public.bazar_history FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read-write for store_records" ON public.store_records FOR ALL USING (true) WITH CHECK (true);
