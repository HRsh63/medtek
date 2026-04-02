-- Supabase Schema for MediTap

-- 1. Create Patients Table
CREATE TABLE public.patients (
    id UUID DEFAULT auth.uid() PRIMARY KEY,
    auth_id UUID REFERENCES auth.users(id),
    full_name TEXT NOT NULL,
    phone TEXT,
    email TEXT
);

-- 2. Create Health Profiles Table
CREATE TABLE public.health_profiles (
    patient_id UUID REFERENCES public.patients(id) PRIMARY KEY,
    blood_group TEXT,
    age INT,
    gender TEXT,
    allergies TEXT[],
    current_medications TEXT[],
    chronic_conditions TEXT[],
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    address TEXT,
    notes TEXT
);

-- 3. Create Medical Records Table
CREATE TABLE public.medical_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID REFERENCES public.patients(id),
    record_type TEXT,
    record_date DATE,
    notes TEXT,
    file_url TEXT
);

-- 4. Create Insurance Companies Table
CREATE TABLE public.insurance_companies (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

-- 5. Create Hospitals Table
CREATE TABLE public.hospitals (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

-- 6. Create Insurance Policies Table
CREATE TABLE public.insurance_policies (
    id TEXT PRIMARY KEY,
    patient_id UUID REFERENCES public.patients(id),
    provider TEXT NOT NULL,
    policy_number TEXT NOT NULL,
    coverage_amount TEXT,
    status TEXT DEFAULT 'active'
);

-- 7. Create Insurance Claims Table
CREATE TABLE public.insurance_claims (
    id TEXT PRIMARY KEY,
    policy_id TEXT REFERENCES public.insurance_policies(id),
    patient_id UUID REFERENCES public.patients(id),
    claim_amount TEXT,
    hospital_name TEXT,
    status TEXT DEFAULT 'open',
    date DATE
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.insurance_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.insurance_claims ENABLE ROW LEVEL SECURITY;

-- Create Policies (Allow users to read/write their own data)
CREATE POLICY "Users can view own patient profile" ON public.patients FOR SELECT USING (auth.uid() = auth_id);
CREATE POLICY "Users can insert own patient profile" ON public.patients FOR INSERT WITH CHECK (auth.uid() = auth_id);
CREATE POLICY "Users can update own patient profile" ON public.patients FOR UPDATE USING (auth.uid() = auth_id);

CREATE POLICY "Users can view own health profile" ON public.health_profiles FOR SELECT USING (patient_id = auth.uid());
CREATE POLICY "Users can modify own health profile" ON public.health_profiles FOR ALL USING (patient_id = auth.uid());

CREATE POLICY "Users can view own medical records" ON public.medical_records FOR SELECT USING (patient_id = auth.uid());
CREATE POLICY "Users can modify own medical records" ON public.medical_records FOR ALL USING (patient_id = auth.uid());

CREATE POLICY "Users can view own policies" ON public.insurance_policies FOR SELECT USING (patient_id = auth.uid() OR patient_id IS NULL);
CREATE POLICY "Users can view own claims" ON public.insurance_claims FOR SELECT USING (patient_id = auth.uid() OR patient_id IS NULL);

-- Insert Initial Mock Lookups
INSERT INTO public.insurance_companies (id, name) VALUES ('ins-1', 'SafeCare Health Insurance') ON CONFLICT DO NOTHING;
INSERT INTO public.hospitals (id, name) VALUES ('hosp-1', 'MediCity General Hospital') ON CONFLICT DO NOTHING;
