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

## 📋 Complete Interview Follow-Up Questions & Answers (Page 13)

### 1. Flutter
1. **Why did you choose your state-management approach?**
   > We utilized `Provider` (`ChangeNotifierProvider`), the Flutter-recommended lightweight and robust solution. It decouples UI from network calls, provides granular widget rebuilding, and simplifies async state lifecycle (loading, success, empty, error).

2. **How does Flutter communicate with your API?**
   > Through a dedicated singleton `ApiService` using the `http` package, sending typed JSON envelopes with configurable timeouts, request headers, error parsing, and fallback mock resilience.

3. **How do you handle API loading/error states?**
   > `AppStateProvider` exposes boolean flags (`isLoadingPackages`, `isLoadingDoctors`, `isLookupLoading`) and nullable error strings. Widgets reactively render loading spinners (`CircularProgressIndicator`), error snackbars, and fallback empty states (`SearchOff`).

4. **How would you improve the application's performance?**
   > Implement list pagination / infinite scrolling, image caching with memory bounds, CDN asset caching, and Dart2Wasm compilation for near-native web execution speeds.

---

### 2. NestJS
1. **Explain your controller/service/module architecture.**
   > The application adheres to NestJS modular design where each domain (`auth`, `users`, `packages`, `tests`, `doctors`, `bookings`, `appointments`, `reviews`, `partners`, `newsletter`) is encapsulated in its own module with dedicated Controllers (handling HTTP transport & routing), Services (business logic & Prisma queries), and DTOs (type definitions with validation decorators).

2. **What is dependency injection in NestJS?**
   > Inversion of Control (IoC) pattern where classes declare their dependencies in constructors via TypeScript tokens, and NestJS runtime instantiates and injects singletons (e.g. `PrismaService` injected into `BookingsService` or `UsersService` injected into `AuthService`).

3. **How did you validate API requests?**
   > Using NestJS `ValidationPipe` paired with `class-validator` and `class-transformer` decorators (`@IsString()`, `@IsEmail()`, `@IsEnum()`, `@Min()`, `@IsDateString()`), enforcing strict payload schemas.

4. **How would you protect private APIs?**
   > Implement JWT authentication with `@nestjs/passport` and Passport-JWT strategy, applying `@UseGuards(JwtAuthGuard)` and `@ApiBearerAuth()`.

---

### 3. PostgreSQL
1. **Explain your database relationships.**
   > Relational 3NF design: `User` has 1-to-Many relationships with `TestBooking` and `DoctorAppointment`; `TestBooking` has a 1-to-Many cascade relationship with `TestBookingItem`, allowing multiple packages and tests per transaction; `HealthPackage` and `LabTest` belong to their respective category tables via foreign keys; `DoctorAppointment` links to `Doctor`.

2. **Why did you choose these tables?**
   > To cleanly decouple user accounts, diagnostic packages/tests, home collections, specialist doctor directories, consultation appointments, and verified customer testimonials while avoiding data redundancy.

3. **Where would you add indexes?**
   > 1. Unique index on `bookingNumber` & `appointmentNumber` for O(1) order tracking.
   > 2. Index on `patientPhone` and `email` for fast lookup of patient records and auth without full table scans.
   > 3. Foreign key indexes on `categorySlug` and `specialtySlug` for catalog filtering.

4. **What happens when two users modify the same data?**
   > PostgreSQL provides ACID guarantees with Multi-Version Concurrency Control (MVCC). For critical operations like booking a doctor's limited time slot, pessimistic locking (`SELECT FOR UPDATE`) or transactional isolation (`SERIALIZABLE`) ensures slot double-booking cannot occur.

---

### 4. General
1. **Explain the complete request flow from Flutter to PostgreSQL.**
   > 1. User interacts with Flutter UI (e.g., clicks Book Test).
   > 2. `AppStateProvider` dispatches action to `ApiService`.
   > 3. `ApiService` makes an HTTP REST request with JSON payload to NestJS (`http://localhost:4000/api/...`).
   > 4. NestJS Global `ValidationPipe` validates incoming DTO against rules.
   > 5. NestJS Controller passes validated DTO to the Service.
   > 6. Service uses `PrismaClient` to execute SQL queries on PostgreSQL.
   > 7. Result is wrapped with `TransformInterceptor` (`{ success: true, message, data }`) and returned to Flutter.
   > 8. Flutter updates Provider state and UI rebuilds reactively.

2. **What problems did you face?**
   > Coordinating multi-item cart structures for combined package and lab test bookings with dynamic coupon discount calculations, and ensuring responsive layouts that adapt smoothly across desktop, tablet, and mobile screen sizes.

3. **Which parts were developed using AI?**
   > AI was leveraged for accelerated boilerplate generation, TypeScript DTO mappings, Flutter widget layout scaffolding, and database schema normalization.

4. **How did you verify AI-generated code?**
   > Through automated TypeScript builds (`npm run build`), strict Dart analysis (`flutter analyze`), Jest unit tests (`npm test`), and Flutter unit/widget tests (`flutter test`), ensuring zero lints and zero errors.

5. **If given another day, what would you improve?**
   > Integrate real payment gateway (Razorpay/Stripe), add live SMS/WhatsApp order tracking updates with webhooks, and implement automated PDF lab report generation.
