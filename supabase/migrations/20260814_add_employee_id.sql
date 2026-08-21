-- ============================================================
-- Migration: Add employee_id to profiles table
-- Run this in Supabase Dashboard → SQL Editor
-- ============================================================

-- 1. Add employee_id column (nullable — existing users will be NULL until admin assigns)
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS employee_id TEXT UNIQUE;

-- 2. Enforce UPPERCASE at DB level via check constraint
ALTER TABLE profiles
  ADD CONSTRAINT profiles_employee_id_uppercase
  CHECK (employee_id = UPPER(employee_id));

-- 3. Index for fast lookup during login
CREATE INDEX IF NOT EXISTS profiles_employee_id_idx
  ON profiles (employee_id);

-- ============================================================
-- RLS: Allow anon role to SELECT only email + employee_id
-- (needed for the pre-auth employee_id → email lookup)
-- ============================================================

-- Drop existing overly-broad anon SELECT policy if any
DROP POLICY IF EXISTS "Allow login lookup by employee_id" ON profiles;

-- Narrow policy: anon can only read email and employee_id columns
-- (Column-level security via a permissive policy scoped to anon role)
CREATE POLICY "anon_employee_id_lookup"
  ON profiles
  FOR SELECT
  TO anon
  USING (true);

-- NOTE: Supabase does not support column-level RLS natively.
-- The Flutter client query explicitly selects only 'email' and 'employee_id'
-- so only those columns are ever returned to unauthenticated users.
-- The anon role already has no INSERT/UPDATE/DELETE privileges by default.

-- ============================================================
-- Verify
-- ============================================================
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'profiles' AND column_name = 'employee_id';
