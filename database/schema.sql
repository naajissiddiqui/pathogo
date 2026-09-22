CREATE TYPE "BookingStatus" AS ENUM (
  'PENDING',
  'CONFIRMED',
  'SAMPLE_COLLECTED',
  'PROCESSING',
  'REPORT_READY',
  'CANCELLED'
);

CREATE TYPE "AppointmentStatus" AS ENUM (
  'PENDING',
  'CONFIRMED',
  'COMPLETED',
  'CANCELLED'
);

CREATE TYPE "CollectionType" AS ENUM (
  'HOME_COLLECTION',
  'LAB_VISIT'
);

CREATE TYPE "Gender" AS ENUM (
  'MALE',
  'FEMALE',
  'OTHER'
);

CREATE TABLE "User" (
  "id" VARCHAR(64) PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "phone" VARCHAR(32) NOT NULL,
  "password" VARCHAR(255) NOT NULL,
  "gender" "Gender" DEFAULT 'MALE',
  "age" INTEGER,
  "city" VARCHAR(128),
  "address" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_user_email" ON "User"("email");
CREATE INDEX "idx_user_phone" ON "User"("phone");

CREATE TABLE "PackageCategory" (
  "id" VARCHAR(64) PRIMARY KEY,
  "slug" VARCHAR(64) UNIQUE NOT NULL,
  "name" VARCHAR(128) NOT NULL,
  "description" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "HealthPackage" (
  "id" VARCHAR(64) PRIMARY KEY,
  "slug" VARCHAR(128) UNIQUE NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "description" TEXT NOT NULL,
  "categorySlug" VARCHAR(64) NOT NULL REFERENCES "PackageCategory"("slug") ON DELETE RESTRICT,
  "originalPrice" DOUBLE PRECISION NOT NULL,
  "discountPrice" DOUBLE PRECISION NOT NULL,
  "discountPercent" INTEGER NOT NULL,
  "testCount" INTEGER NOT NULL,
  "isPopular" BOOLEAN DEFAULT FALSE NOT NULL,
  "reportTimeHours" INTEGER DEFAULT 24 NOT NULL,
  "fastingRequired" BOOLEAN DEFAULT FALSE NOT NULL,
  "includedSummary" TEXT[] DEFAULT ARRAY[]::TEXT[],
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_healthpackage_category" ON "HealthPackage"("categorySlug");

CREATE TABLE "TestCategory" (
  "id" VARCHAR(64) PRIMARY KEY,
  "slug" VARCHAR(64) UNIQUE NOT NULL,
  "name" VARCHAR(128) NOT NULL,
  "iconName" VARCHAR(64) NOT NULL,
  "testsCount" INTEGER DEFAULT 0 NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "LabTest" (
  "id" VARCHAR(64) PRIMARY KEY,
  "slug" VARCHAR(128) UNIQUE NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "code" VARCHAR(64),
  "categorySlug" VARCHAR(64) NOT NULL REFERENCES "TestCategory"("slug") ON DELETE RESTRICT,
  "price" DOUBLE PRECISION NOT NULL,
  "originalPrice" DOUBLE PRECISION,
  "description" TEXT NOT NULL,
  "fastingRequired" BOOLEAN DEFAULT FALSE NOT NULL,
  "reportTimeHours" INTEGER DEFAULT 24 NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_labtest_category" ON "LabTest"("categorySlug");

CREATE TABLE "Doctor" (
  "id" VARCHAR(64) PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "slug" VARCHAR(128) UNIQUE NOT NULL,
  "specialty" VARCHAR(128) NOT NULL,
  "specialtySlug" VARCHAR(128) NOT NULL,
  "experienceYrs" INTEGER NOT NULL,
  "qualification" VARCHAR(255) NOT NULL,
  "hospital" VARCHAR(255) NOT NULL,
  "consultationFee" DOUBLE PRECISION NOT NULL,
  "rating" DOUBLE PRECISION DEFAULT 4.9 NOT NULL,
  "reviewCount" INTEGER DEFAULT 0 NOT NULL,
  "imageUrl" TEXT NOT NULL,
  "availableDays" TEXT[] DEFAULT ARRAY[]::TEXT[],
  "timeSlots" TEXT[] DEFAULT ARRAY[]::TEXT[],
  "about" TEXT NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_doctor_specialty" ON "Doctor"("specialtySlug");

CREATE TABLE "LabPartner" (
  "id" VARCHAR(64) PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "logoUrl" TEXT,
  "rating" DOUBLE PRECISION DEFAULT 4.9 NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "TestBooking" (
  "id" VARCHAR(64) PRIMARY KEY,
  "bookingNumber" VARCHAR(64) UNIQUE NOT NULL,
  "userId" VARCHAR(64) REFERENCES "User"("id") ON DELETE SET NULL,
  "patientName" VARCHAR(255) NOT NULL,
  "patientEmail" VARCHAR(255) NOT NULL,
  "patientPhone" VARCHAR(32) NOT NULL,
  "patientAge" INTEGER NOT NULL,
  "patientGender" "Gender" DEFAULT 'MALE' NOT NULL,
  "collectionType" "CollectionType" DEFAULT 'HOME_COLLECTION' NOT NULL,
  "address" TEXT,
  "city" VARCHAR(128),
  "pincode" VARCHAR(16),
  "scheduledDate" TIMESTAMP WITH TIME ZONE NOT NULL,
  "scheduledSlot" VARCHAR(64) NOT NULL,
  "couponCode" VARCHAR(64),
  "discountAmount" DOUBLE PRECISION DEFAULT 0 NOT NULL,
  "totalAmount" DOUBLE PRECISION NOT NULL,
  "status" "BookingStatus" DEFAULT 'CONFIRMED' NOT NULL,
  "notes" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_testbooking_phone" ON "TestBooking"("patientPhone");
CREATE INDEX "idx_testbooking_number" ON "TestBooking"("bookingNumber");
CREATE INDEX "idx_testbooking_user" ON "TestBooking"("userId");

CREATE TABLE "TestBookingItem" (
  "id" VARCHAR(64) PRIMARY KEY,
  "bookingId" VARCHAR(64) NOT NULL REFERENCES "TestBooking"("id") ON DELETE CASCADE,
  "packageId" VARCHAR(64) REFERENCES "HealthPackage"("id") ON DELETE SET NULL,
  "testId" VARCHAR(64) REFERENCES "LabTest"("id") ON DELETE SET NULL,
  "unitPrice" DOUBLE PRECISION NOT NULL,
  "quantity" INTEGER DEFAULT 1 NOT NULL
);

CREATE INDEX "idx_bookingitem_booking" ON "TestBookingItem"("bookingId");

CREATE TABLE "DoctorAppointment" (
  "id" VARCHAR(64) PRIMARY KEY,
  "appointmentNumber" VARCHAR(64) UNIQUE NOT NULL,
  "userId" VARCHAR(64) REFERENCES "User"("id") ON DELETE SET NULL,
  "doctorId" VARCHAR(64) NOT NULL REFERENCES "Doctor"("id") ON DELETE RESTRICT,
  "patientName" VARCHAR(255) NOT NULL,
  "patientEmail" VARCHAR(255) NOT NULL,
  "patientPhone" VARCHAR(32) NOT NULL,
  "patientAge" INTEGER NOT NULL,
  "patientGender" "Gender" DEFAULT 'MALE' NOT NULL,
  "appointmentDate" TIMESTAMP WITH TIME ZONE NOT NULL,
  "appointmentSlot" VARCHAR(64) NOT NULL,
  "consultationType" VARCHAR(32) DEFAULT 'VIDEO' NOT NULL,
  "symptoms" TEXT,
  "status" "AppointmentStatus" DEFAULT 'CONFIRMED' NOT NULL,
  "consultationFee" DOUBLE PRECISION NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX "idx_appointment_doctor" ON "DoctorAppointment"("doctorId");
CREATE INDEX "idx_appointment_phone" ON "DoctorAppointment"("patientPhone");
CREATE INDEX "idx_appointment_number" ON "DoctorAppointment"("appointmentNumber");
CREATE INDEX "idx_appointment_user" ON "DoctorAppointment"("userId");

CREATE TABLE "Review" (
  "id" VARCHAR(64) PRIMARY KEY,
  "author" VARCHAR(255) NOT NULL,
  "rating" INTEGER DEFAULT 5 NOT NULL,
  "comment" TEXT NOT NULL,
  "verified" BOOLEAN DEFAULT TRUE NOT NULL,
  "location" VARCHAR(128),
  "avatarUrl" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "NewsletterSubscriber" (
  "id" VARCHAR(64) PRIMARY KEY,
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
