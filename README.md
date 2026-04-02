# MediTap 🧬

**"Tap. Scan. Save a Life."**

MediTap is a mission-critical emergency medical identity platform designed to provide instant access to life-saving information. In critical moments where every second counts, MediTap allows emergency responders to access a patient's medical profile through simple, non-intrusive methods like NFC taps, QR scans, or phone number lookups.

---

## 🌟 Core Features

### 🏥 For Hospitals & First Responders
- **Instant Patient Lookup:** Find critical health data (allergies, blood group, medications) in under one second.
- **Three-Way Access:** 
  - **NFC Tap:** Simply tap a device to retrieve data.
  - **QR Code Scan:** Scan a permanent, unique patient QR code.
  - **Phone Search:** Search if a patient is registered using their phone number.
- **Emergency-Mode UI:** High-contrast, rapid-read medical summaries designed for the chaos of an ER.

### 👤 For Patients
- **Medical ID Management:** Securely store your blood type, chronic conditions, and emergency contacts.
- **Permanent QR Access:** Generate a unique QR that never changes, even if you update your info.
- **Subscription Portals:** Integrated support for Free and Premium (NFC-enabled) tiers.
- **Privacy First:** Detailed access logs showing exactly when and where your medical profile was viewed.

### 🛡️ For Insurance Providers
- **Direct Record Upload:** Verified insurance companies can push medical records (scans, labs, prescriptions) directly to a patient's digital locker.
- **Automated Verification:** Seamlessly confirm coverage status for hospitals during triage.

---

## 🚀 Tech Stack

- **Frontend:** [Next.js 14](https://nextjs.org/) (App Router), [Tailwind CSS](https://tailwindcss.com/)
- **Animations:** [Framer Motion](https://www.framer.com/motion/)
- **Database & Auth:** [Supabase](https://supabase.com/) (Real-time DB, Auth, Storage)
- **Icons:** [Lucide React](https://lucide.dev/)
- **QR/NFC Tools:** `react-qr-code`, `html5-qrcode`

---

## 🧪 Mock Prototype Mode

The application is currently configured in **Mock Prototype Mode**. This allows you to explore all features (Patient Dashboard, Hospital ER Lookup, Insurance Portal) without needing a live database connection or valid credentials.

- **Mock Data:** Located in [`lib/supabase.ts`](./lib/supabase.ts).
- **Hardcoded User:** You can "log in" to any portal; the system will treat you as a verified mock user (e.g., John Doe).
- **No Backend Required:** You don't need to configure Supabase to see the UI and interactions.

### To Enable Live Supabase:
If you want to use a real backend:
1. Replace [`lib/supabase.ts`](./lib/supabase.ts) with a standard Supabase client initialization.
2. Ensure your `.env.local` is filled with valid keys.
3. Apply the schema in `supabase_schema.sql`.

---

## 🛠️ Getting Started

### 1. Clone & Install
```bash
git clone <your-repo-url>
cd meditap
npm install
```

### 2. Environment Variables
Create a `.env.local` file in the root directory:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. Database Setup
1. Create a new project on [Supabase](https://supabase.com/).
2. Navigate to the **SQL Editor**.
3. Run the contents of [`supabase_schema.sql`](./supabase_schema.sql) to initialize the tables, RLS policies, and triggers.
4. Enable **Storage** and create a bucket named `medical-records`.

### 4. Run Locally
```bash
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) to see the app.

---

## 📂 Project Structure

```text
├── app/                  # Next.js App Router (Pages, Layouts)
│   ├── hospital/         # ER/Responder portal
│   ├── patient/          # Individual user dashboard
│   ├── insurance/        # Provider portal
│   └── api/              # Serverless functions
├── components/           # Reusable UI components
│   ├── shared/           # Common layouts, Auth guards
│   └── ui/               # Primary visual elements
├── lib/                  # Configurations (Supabase client)
└── supabase_schema.sql   # Database structure & RLS policies
```

---

## 🔐 Security & Privacy

MediTap uses **Row Level Security (RLS)** to ensure data privacy:
- **Patients** can only see and edit their own data.
- **Hospitals** can view patient records only during lookup/emergency sessions.
- **Insurance** companies can only upload and view records they have authorized access to.

---

## 📄 License
This project is for emergency medical identity demonstration purposes.
