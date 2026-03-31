-- PHASE 2 — SUPABASE SCHEMA
-- Run this in your Supabase SQL Editor

-- 1. Patients Table
create table patients (
  id uuid primary key default gen_random_uuid(),
  auth_id uuid references auth.users(id),
  full_name text,
  phone text unique,
  email text unique,
  subscription_status text default 'free',
  insurance_company_id uuid, -- will reference insurance_companies(id) later
  created_at timestamp with time zone default now()
);

-- 2. Insurance Companies Table
create table insurance_companies (
  id uuid primary key default gen_random_uuid(),
  auth_id uuid references auth.users(id),
  name text not null,
  created_at timestamp with time zone default now()
);

-- Update patients table to add the foreign key now that insurance_companies exists
alter table patients add constraint fk_insurance foreign key (insurance_company_id) references insurance_companies(id);

-- 3. Hospitals Table
create table hospitals (
  id uuid primary key default gen_random_uuid(),
  auth_id uuid references auth.users(id),
  name text not null,
  address text,
  registration_number text unique,
  created_at timestamp with time zone default now()
);

-- 4. Health Profiles Table
create table health_profiles (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid references patients(id) on delete cascade unique,
  age int,
  gender text,
  weight_kg numeric,
  height_cm numeric,
  blood_group text,
  address text,
  emergency_contact_name text,
  emergency_contact_phone text,
  allergies text[],
  chronic_conditions text[],
  current_medications text[],
  disabilities text[],
  past_surgeries text[],
  family_history text[],
  vaccination_history text[],
  notes text,
  filled_via text check (filled_via in ('manual', 'insurance', 'initial')),
  last_updated timestamp with time zone default now()
);

-- 5. Medical Records Table
create table medical_records (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid references patients(id) on delete cascade,
  uploaded_by_insurance uuid references insurance_companies(id),
  record_type text check (record_type in ('checkup', 'lab', 'prescription', 'scan')),
  file_url text,
  notes text,
  record_date date,
  created_at timestamp with time zone default now()
);

-- 6. Patient Keys Table
create table patient_keys (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid references patients(id) on delete cascade unique,
  qr_payload text unique,
  nfc_payload text unique,
  generated_at timestamp with time zone default now()
);

-- 7. Access Logs Table
create table access_logs (
  id uuid primary key default gen_random_uuid(),
  hospital_id uuid references hospitals(id),
  patient_id uuid references patients(id),
  accessed_at timestamp with time zone default now(),
  method text check (method in ('qr', 'nfc', 'phone'))
);

-- STORAGE BUCKET (Run via UI or CLI)
-- Name: medical-records
-- Public: false (or private, with policies)

-- ENABLE RLS
alter table patients enable row level security;
alter table health_profiles enable row level security;
alter table medical_records enable row level security;
alter table patient_keys enable row level security;
alter table insurance_companies enable row level security;
alter table hospitals enable row level security;
alter table access_logs enable row level security;

-- POLICIES

-- Patients
create policy "Patients can view their own row" on patients for select using (auth.uid() = auth_id);
create policy "Patients can update their own row" on patients for update using (auth.uid() = auth_id);
create policy "Patients can insert their own row" on patients for insert with check (auth.uid() = auth_id);

-- Health Profiles
create policy "Patients can view/edit their own profile" on health_profiles for all using (
  exists (select 1 from patients where id = health_profiles.patient_id and auth_id = auth.uid())
);
create policy "Hospitals can read health profiles" on health_profiles for select using (
  exists (select 1 from hospitals where auth_id = auth.uid())
);

-- Medical Records
create policy "Insurance can write records" on medical_records for insert with check (
  exists (select 1 from insurance_companies where auth_id = auth.uid() and id = medical_records.uploaded_by_insurance)
);
create policy "Patients can read their records" on medical_records for select using (
  exists (select 1 from patients where id = medical_records.patient_id and auth_id = auth.uid())
);
create policy "Hospitals can read patient records" on medical_records for select using (
  exists (select 1 from hospitals where auth_id = auth.uid())
);

-- Patient Keys
create policy "Patients can read their keys" on patient_keys for select using (
  exists (select 1 from patients where id = patient_keys.patient_id and auth_id = auth.uid())
);
create policy "Hospitals can lookup all keys" on patient_keys for select using (
  exists (select 1 from hospitals where auth_id = auth.uid())
);

-- Access Logs
create policy "Hospitals can write logs" on access_logs for insert with check (
  exists (select 1 from hospitals where auth_id = auth.uid() and id = access_logs.hospital_id)
);
create policy "Patients can view their own logs" on access_logs for select using (
  exists (select 1 from patients where id = access_logs.patient_id and auth_id = auth.uid())
);
