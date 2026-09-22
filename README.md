# Pathogo - Full-Stack Healthcare & Diagnostics Web Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![NestJS](https://img.shields.io/badge/NestJS-10+-E0234E?logo=nestjs&logoColor=white)](https://nestjs.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Prisma](https://img.shields.io/badge/Prisma-5.22+-2D3748?logo=prisma&logoColor=white)](https://www.prisma.io)
[![Swagger](https://img.shields.io/badge/Swagger-OpenAPI-85EA2D?logo=swagger&logoColor=black)](http://localhost:4000/api/docs)

A production-grade full-stack healthcare platform built strictly in accordance with the assignment specifications and reference design.

---

## 📸 Reference Design Implementation (Pages 1 to 6)

| UI Section | Reference Design Element | Implementation Details |
| :--- | :--- | :--- |
| **Page 1** | Hero Section & Trust Badges | 10k+ Patients badge, stats pill row, CTAs, right quick-action cards (`Book a Collection`, `View Reports`, `Helpline`) |
| **Page 1** | Lab Partners Strip | Partner network: MAX Healthcare, METROPOLIS, Redcliffe Labs, TATA 1mg, Thyrocare, Agilus |
| **Page 1 & 2** | Popular Packages | Filter tabs (`All`, `Basic`, `Advance`, `Women`, `Men`, `Kids`, `Couple`, `Corporate`), discount ribbons (`UPTO 54% OFF`), test counts, ₹ pricing, Book Now modal |
| **Page 2** | Promotional Offers | 50% Cashback + 20% Off coupon banner (`FLEBO2050` with 1-tap copy) & Exciting Alert Card |
| **Page 3** | Tests by Category | 9 circular organ icons (`Bone`, `Diabetes`, `Gastro`, `Gynae`, `Heart`, `Kidney`, `Liver`, `Prostate`, `Thyroid`) |
| **Page 3** | Check Your Vitals | 4 high-res photo cards (`Fever`, `STD Care`, `Diabetic`, `Thyroid`) |
| **Page 3 & 4** | Disease Specialists | Specialist category pills (`Cardiology`, `Nephrology`, `Neurology`, `Endocrinology`, etc.) + Doctor cards with experience, fee, View Details, and Book Appointment flows |
| **Page 4** | Media Coverage | Video consultation preview banner with TV news frame and audio/video controls |
| **Page 5** | App Promo & Reviews | First-time booking card, app store download card, and 4.9 ★★★★★ verified customer review cards |
| **Page 6** | Newsletter & SEO Footer | Newsletter email subscription with backend validation, multi-column directory keywords, contact helpline, and legal links |

---

## 🏗 System Architecture

```
                               ┌─────────────────────────────┐
                               │   Flutter Web Application   │
                               │  (Dart, Responsive Layout,  │
                               │   Provider State Management)│
                               └──────────────┬──────────────┘
                                              │ REST API (JSON)
                                              ▼
                               ┌─────────────────────────────┐
                               │     NestJS REST Backend     │
                               │ (Controllers, Services, DTOs│
                               │  ValidationPipe, Swagger)   │
                               └──────────────┬──────────────┘
                                              │ Prisma ORM
                                              ▼
                               ┌─────────────────────────────┐
                               │     PostgreSQL Database     │
                               │ (Packages, Doctors, Bookings│
                               │ Appointments, Reviews, Seed)│
                               └─────────────────────────────┘
```

---

## 🚀 Quick Start Guide

### Prerequisites
- **Node.js**: v18+ (v20+ recommended)
- **Flutter SDK**: v3.19+ (Web enabled)
- **PostgreSQL**: Local instance or Docker

---

### Step 1: Start PostgreSQL (Docker or Local)

Using Docker Compose:
```bash
docker compose up -d
```
Or use an existing PostgreSQL instance and set `DATABASE_URL` in `backend/.env`.

---

### Step 2: Setup and Run NestJS Backend

```bash
cd backend

# 1. Install dependencies
npm install

# 2. Copy environment file
cp .env.example .env

# 3. Generate Prisma client & Push database schema
npx prisma generate
npx prisma db push

# 4. Seed database with realistic healthcare data
npx prisma db seed

# 5. Start development server
npm run start:dev
```
- 🌐 **Backend API**: `http://localhost:4000/api`
- 📚 **Swagger Interactive Docs**: `http://localhost:4000/api/docs`

---

### Step 3: Setup and Run Flutter Web Frontend

```bash
cd frontend

# 1. Get Flutter packages
flutter pub get

# 2. Run Flutter Web on Chrome
flutter run -d chrome --web-port 3000
```
Or build the optimized web bundle:
```bash
flutter build web --release
```

---

## 📡 REST API Catalog

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | Register new user/patient with password hashing | Public |
| `POST` | `/api/auth/login` | Login with email & password, returns JWT token | Public |
| `GET` | `/api/auth/me` | Get current logged in profile & booking history | Bearer JWT |
| `GET` | `/api/users` | List all registered users (search by query) | Public / Admin |
| `GET` | `/api/users/:id` | Get user details by ID | Public / Admin |
| `POST` | `/api/users` | Create user profile directly | Public / Admin |
| `PATCH` | `/api/users/:id` | Update user details by ID | Bearer JWT |
| `DELETE` | `/api/users/:id` | Delete user account by ID | Bearer JWT |
| `GET` | `/api/packages` | List all health packages (supports `?category=women&search=heart`) | Public |
| `GET` | `/api/packages/categories` | List package filter categories | Public |
| `GET` | `/api/packages/:slug` | Get package details by slug | Public |
| `GET` | `/api/tests` | List all lab tests with search/category filters | Public |
| `GET` | `/api/tests/categories` | List organ test categories | Public |
| `GET` | `/api/doctors` | List specialists with specialty filters | Public |
| `GET` | `/api/doctors/:id` | Get doctor full profile & time slots | Public |
| `POST` | `/api/bookings` | Create home sample collection / lab booking | Public / Linked |
| `GET` | `/api/bookings/lookup?phone=...` | Lookup all test bookings by phone number | Public |
| `GET` | `/api/bookings/:bookingNumber` | Get booking tracking by code (e.g. `PTG-2026-9812`) | Public |
| `POST` | `/api/appointments` | Book doctor consultation appointment | Public / Linked |
| `GET` | `/api/appointments/lookup?phone=...` | Lookup doctor appointments by phone number | Public |
| `GET` | `/api/reviews` | Get verified customer testimonials | Public |
| `GET` | `/api/partners` | Get certified lab partner network | Public |
| `POST` | `/api/newsletter/subscribe` | Subscribe email to newsletter | Public |

---

## 🧪 How to Test & Verification Activities

### 1. Run Automated Unit & Integration Tests
```bash
# Frontend Flutter Tests (5 tests: models, package calculations, doctor parsing, widget tests)
cd frontend
flutter test

# Backend NestJS Tests (Jest tests for AuthService, token generation, password hashing)
cd backend
npm test
```

### 2. Live Interactive User Testing (Step-by-Step Activities)

#### Activity A: Authentication (Register & Login)
1. In the top navbar, click **"Sign In"**.
2. Click **"Fill"** next to Demo credentials (`rahul@pathogo.com` / `Password123!`) or click **"Register"** tab to create a new patient account.
3. Click **"Sign In"**.
4. Notice the navbar changes to show the green user pill with the patient name.
5. Click on the user pill to see **"My Bookings & Reports"** or **"Logout"**.

#### Activity B: Book a Home Collection Test
1. Click **"Book a Test"** in the navbar or on any **Package Card**.
2. If logged in, patient details (Name, Email, Phone, Address) are **automatically pre-filled**.
3. Apply coupon code `FLEBO2050` or `PATHOGO20` and notice the 20% discount applied in real time.
4. Select date, time slot, and home collection address.
5. Click **"Confirm & Book Collection"**.
6. A booking confirmation screen displays with a unique tracking code (e.g., `PTG-2026-XXXX`).

#### Activity C: Book a Specialist Doctor Consultation
1. Scroll to the **"Consult Top Specialists"** section.
2. Select a specialty (e.g. `Cardiology` or `Nephrology`).
3. Click **"Book Appointment"** on a doctor card (e.g., Dr. Priya Sharma).
4. Select consultation date, time slot (`10:00 AM`), and add symptoms.
5. Submit to receive instant appointment confirmation.

#### Activity D: Track Bookings & View Reports
1. In the navbar, click **"Reports & Status"** (or in the user dropdown, select "My Bookings & Reports").
2. Enter phone number `9876543210` or booking ID `PTG-2026-9812`.
3. Click **"Track"**.
4. Real-time booking details, sample collection status, doctor consultations, and test parameters are rendered.

#### Activity E: Subscribe to Newsletter
1. Scroll to the bottom newsletter banner.
2. Enter your email (e.g. `user@example.com`) and click **"Subscribe"**.
3. Immediate confirmation notification is displayed.

---