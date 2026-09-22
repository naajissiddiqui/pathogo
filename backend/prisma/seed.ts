import { PrismaClient, BookingStatus, AppointmentStatus, CollectionType, Gender } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed for Pathogo Healthcare...');

  await prisma.testBookingItem.deleteMany();
  await prisma.testBooking.deleteMany();
  await prisma.doctorAppointment.deleteMany();
  await prisma.user.deleteMany();
  await prisma.labTest.deleteMany();
  await prisma.testCategory.deleteMany();
  await prisma.healthPackage.deleteMany();
  await prisma.packageCategory.deleteMany();
  await prisma.doctor.deleteMany();
  await prisma.labPartner.deleteMany();
  await prisma.review.deleteMany();
  await prisma.newsletterSubscriber.deleteMany();

  console.log('👤 Seeding Demo Users...');
  const defaultPasswordHash = await bcrypt.hash('Password123!', 10);
  const demoUser1 = await prisma.user.create({
    data: {
      name: 'Rahul Sharma',
      email: 'rahul@pathogo.com',
      phone: '9876543210',
      password: defaultPasswordHash,
      gender: Gender.MALE,
      age: 30,
      city: 'Gurugram',
      address: 'Flat 402, Sunshine Heights, Sector 45',
    },
  });

  const demoUser2 = await prisma.user.create({
    data: {
      name: 'Priya Verma',
      email: 'priya.verma@example.com',
      phone: '9812345678',
      password: defaultPasswordHash,
      gender: Gender.FEMALE,
      age: 27,
      city: 'Delhi',
      address: 'B-12, Green Park Extension',
    },
  });

  console.log('🏥 Seeding Lab Partners...');
  await prisma.labPartner.createMany({
    data: [
      { name: 'MAX Healthcare', logoUrl: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=100&auto=format&fit=crop&q=60', rating: 4.9 },
      { name: 'METROPOLIS', logoUrl: 'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=100&auto=format&fit=crop&q=60', rating: 4.8 },
      { name: 'Redcliffe Labs', logoUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=100&auto=format&fit=crop&q=60', rating: 4.9 },
      { name: 'TATA 1mg', logoUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=100&auto=format&fit=crop&q=60', rating: 4.9 },
      { name: 'Thyrocare', logoUrl: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=100&auto=format&fit=crop&q=60', rating: 4.8 },
      { name: 'Agilus Diagnostics', logoUrl: 'https://images.unsplash.com/photo-1583912267670-6575ad472688?w=100&auto=format&fit=crop&q=60', rating: 4.9 },
    ],
  });

  console.log('📦 Seeding Package Categories...');
  const categories = [
    { slug: 'all', name: 'All', description: 'All comprehensive diagnostic packages' },
    { slug: 'basic', name: 'Basic', description: 'Essential baseline wellness and blood health checkups' },
    { slug: 'advance', name: 'Advance', description: 'Deep-dive risk assessments for organs & lifestyle ailments' },
    { slug: 'women', name: 'Women', description: 'Tailored profiles for women hormones, fertility & vitamins' },
    { slug: 'men', name: 'Men', description: 'Targeted men health packages including heart & prostate' },
    { slug: 'kids', name: 'Kids', description: 'Pediatric growth, nutrition, and immunity profiles' },
    { slug: 'couple', name: 'Couple', description: 'Comprehensive dual-screenings for couples & pre-marital care' },
    { slug: 'corporate', name: 'Corporate', description: 'Designed for working executives and busy lifestyle management' },
  ];

  for (const cat of categories) {
    await prisma.packageCategory.create({ data: cat });
  }

  console.log('🩺 Seeding Health Packages...');
  const packages = [
    {
      slug: 'basic-health-package',
      name: 'Basic Health Package',
      categorySlug: 'basic',
      description: 'Complete blood count & 28 essential tests for baseline wellness check.',
      originalPrice: 699,
      discountPrice: 499,
      discountPercent: 28,
      testCount: 28,
      isPopular: false,
      reportTimeHours: 12,
      fastingRequired: false,
      includedSummary: ['Complete Blood Count (CBC)', 'Blood Glucose Fasting', 'Urine Routine Analysis', 'ESR & Platelets'],
    },
    {
      slug: 'body-profiling-package',
      name: 'Body Profiling Package',
      categorySlug: 'basic',
      description: '46 tests for a complete health overview including lipid and liver markers.',
      originalPrice: 1199,
      discountPrice: 799,
      discountPercent: 33,
      testCount: 46,
      isPopular: true,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Complete Blood Count', 'Lipid Profile Basic', 'Liver Function (LFT)', 'Kidney Profile', 'Blood Sugar Fasting'],
    },
    {
      slug: 'advanced-heart-package',
      name: 'Advanced Heart Package',
      categorySlug: 'advance',
      description: 'Comprehensive cardiac risk evaluation, lipid fractionation, and electrolyte balance.',
      originalPrice: 1799,
      discountPrice: 1299,
      discountPercent: 27,
      testCount: 58,
      isPopular: false,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Cardiac Risk Markers', 'High-Sensitivity CRP', 'Lipid Profile Comprehensive', 'Serum Electrolytes', 'Apolipoproteins'],
    },
    {
      slug: 'diabetic-care-package',
      name: 'Diabetic Care Package',
      categorySlug: 'advance',
      description: 'Specialized tests for better diabetes management, HbA1c, and renal safety.',
      originalPrice: 1199,
      discountPrice: 849,
      discountPercent: 29,
      testCount: 35,
      isPopular: false,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['HbA1c Glycosylated Hemoglobin', 'Fasting & PP Blood Sugar', 'Microalbuminuria', 'Lipid Screen', 'Kidney Function Test'],
    },
    {
      slug: 'corporate-health-package',
      name: 'Corporate Health Package',
      categorySlug: 'corporate',
      description: 'Going beyond advanced for busy professionals, this package offers insights into heart risk, HbA1c, thyroid, iron, and stress markers.',
      originalPrice: 2599,
      discountPrice: 1249,
      discountPercent: 52,
      testCount: 70,
      isPopular: true,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Comprehensive CBC (24 tests)', 'HbA1c & Fasting Glucose', 'Lipid Profile Complete', 'Thyroid Profile (T3, T4, TSH)', 'Liver & Kidney Panels', 'Vitamin D & B12 Screening'],
    },
    {
      slug: 'couples-health-package',
      name: 'Couple\'s Health Package',
      categorySlug: 'couple',
      description: 'For couples, this package includes screenings for reproductive health, iron deficiency, heart risk, hormone status, and vital organ function.',
      originalPrice: 4550,
      discountPrice: 1499,
      discountPercent: 67,
      testCount: 86,
      isPopular: false,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Dual Full Body Profiles', 'HbA1c & Blood Glucose', 'Hormone Screening & Thyroid', 'Complete Lipid & Cardiac Risk', 'Iron Profile & Ferritin', 'Vital Vitamin Levels'],
    },
    {
      slug: 'comprehensive-health-package-male',
      name: 'Comprehensive Health Package (Male)',
      categorySlug: 'men',
      description: 'For men over 40, this package includes tests for cancer markers (PSA), hormone imbalances, heart risk, liver vitality & prostate health.',
      originalPrice: 3700,
      discountPrice: 1700,
      discountPercent: 54,
      testCount: 91,
      isPopular: true,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Prostate Specific Antigen (PSA)', 'Total Testosterone & Hormones', 'Full Lipid & Cardiac Screen', 'Liver & Renal Profiles', 'Thyroid Complete', 'Bone Density Calcium & Vit D'],
    },
    {
      slug: 'kidcare-essential-package',
      name: 'KidCare Essential Package',
      categorySlug: 'kids',
      description: 'Designed for growing children, this package covers essential vitamins, immunity, blood formation, calcium, nutrition & thyroid health.',
      originalPrice: 4300,
      discountPrice: 1810,
      discountPercent: 58,
      testCount: 48,
      isPopular: false,
      reportTimeHours: 24,
      fastingRequired: false,
      includedSummary: ['Pediatric Hemogram (CBC)', 'Serum Calcium & Phosphorus', 'Vitamin D3 & B12 Levels', 'Iron Deficiency & Ferritin', 'Thyroid Screening (TSH)', 'Urine Microscopy'],
    },
    {
      slug: 'women-wellness-advance',
      name: 'Women Wellness & Hormone Package',
      categorySlug: 'women',
      description: 'Dedicated women wellness profile covering hormonal balance (FSH, LH, Prolactin), thyroid, bone health, iron, and vitamin essentials.',
      originalPrice: 3899,
      discountPrice: 1649,
      discountPercent: 57,
      testCount: 78,
      isPopular: true,
      reportTimeHours: 24,
      fastingRequired: true,
      includedSummary: ['Complete Hemogram with ESR', 'Thyroid Profile Complete (T3, T4, TSH)', 'Hormone Panel (FSH/LH/Prolactin)', 'Iron Profile & Ferritin', 'Vitamin D3 & B12', 'Lipid & Liver Screen'],
    },
  ];

  for (const pkg of packages) {
    await prisma.healthPackage.create({ data: pkg });
  }

  console.log('🧪 Seeding Test Categories & Lab Tests...');
  const testCats = [
    { slug: 'bone', name: 'Bone', iconName: 'bone', testsCount: 8 },
    { slug: 'diabetes', name: 'Diabetes', iconName: 'activity', testsCount: 12 },
    { slug: 'gastro', name: 'Gastro', iconName: 'utensils', testsCount: 10 },
    { slug: 'gynae', name: 'Gynae', iconName: 'user-check', testsCount: 14 },
    { slug: 'heart', name: 'Heart', iconName: 'heart', testsCount: 16 },
    { slug: 'kidney', name: 'Kidney', iconName: 'droplet', testsCount: 9 },
    { slug: 'liver', name: 'Liver', iconName: 'shield', testsCount: 11 },
    { slug: 'prostate', name: 'Prostate', iconName: 'user', testsCount: 6 },
    { slug: 'thyroid', name: 'Thyroid', iconName: 'zap', testsCount: 7 },
  ];

  for (const tc of testCats) {
    await prisma.testCategory.create({ data: tc });
  }

  const labTests = [
    {
      slug: 'complete-blood-count',
      name: 'Complete Blood Count (CBC)',
      code: 'CBC-01',
      categorySlug: 'bone',
      price: 299,
      originalPrice: 450,
      description: 'Measures red blood cells, white blood cells, hemoglobin, hematocrit, and platelets.',
      fastingRequired: false,
      reportTimeHours: 12,
    },
    {
      slug: 'hba1c-glycated-hemoglobin',
      name: 'Glycosylated Hemoglobin (HbA1c)',
      code: 'HBA-02',
      categorySlug: 'diabetes',
      price: 399,
      originalPrice: 600,
      description: 'Measures 3-month average blood sugar control for diabetic monitoring and diagnosis.',
      fastingRequired: false,
      reportTimeHours: 12,
    },
    {
      slug: 'lipid-profile-heart-risk',
      name: 'Lipid Profile (Heart Risk)',
      code: 'LPD-03',
      categorySlug: 'heart',
      price: 499,
      originalPrice: 750,
      description: 'Assesses total cholesterol, HDL, LDL, VLDL, and triglycerides to evaluate cardiovascular risk.',
      fastingRequired: true,
      reportTimeHours: 24,
    },
    {
      slug: 'liver-function-test',
      name: 'Liver Function Test (LFT) Basic',
      code: 'LFT-04',
      categorySlug: 'liver',
      price: 450,
      originalPrice: 700,
      description: 'Measures SGOT, SGPT, Bilirubin, Alkaline Phosphatase, and Albumin to assess liver function.',
      fastingRequired: true,
      reportTimeHours: 24,
    },
    {
      slug: 'kidney-function-test',
      name: 'Kidney Function Test (KFT / RFT)',
      code: 'KFT-05',
      categorySlug: 'kidney',
      price: 450,
      originalPrice: 700,
      description: 'Measures Urea, Blood Urea Nitrogen (BUN), Creatinine, and Uric Acid to assess kidney filtration.',
      fastingRequired: false,
      reportTimeHours: 24,
    },
    {
      slug: 'thyroid-profile-total',
      name: 'Thyroid Profile Total (T3, T4, TSH)',
      code: 'THY-06',
      categorySlug: 'thyroid',
      price: 350,
      originalPrice: 550,
      description: 'Comprehensive screening for hyperthyroidism and hypothyroidism hormone levels.',
      fastingRequired: true,
      reportTimeHours: 24,
    },
    {
      slug: 'vitamin-d-25-hydroxy',
      name: 'Vitamin D 25-Hydroxy',
      code: 'VIT-07',
      categorySlug: 'bone',
      price: 699,
      originalPrice: 1200,
      description: 'Essential for bone health, immune function, and calcium absorption analysis.',
      fastingRequired: false,
      reportTimeHours: 24,
    },
    {
      slug: 'vitamin-b12-cyanocobalamin',
      name: 'Vitamin B12',
      code: 'VIT-08',
      categorySlug: 'gastro',
      price: 599,
      originalPrice: 950,
      description: 'Vital test for neurological health, red blood cell production, and energy metabolism.',
      fastingRequired: false,
      reportTimeHours: 24,
    },
    {
      slug: 'psa-prostate-specific-antigen',
      name: 'Prostate Specific Antigen (PSA)',
      code: 'PSA-09',
      categorySlug: 'prostate',
      price: 550,
      originalPrice: 900,
      description: 'Screening marker for prostate health, enlargement, or prostate inflammation in men.',
      fastingRequired: false,
      reportTimeHours: 24,
    },
  ];

  for (const lt of labTests) {
    await prisma.labTest.create({ data: lt });
  }

  console.log('👨‍⚕️ Seeding Doctors & Disease Specialists...');
  const doctors = [
    {
      slug: 'dr-priya-sharma',
      name: 'Dr. Priya Sharma',
      specialty: 'Cardiologist',
      specialtySlug: 'cardiology',
      experienceYrs: 8,
      qualification: 'MBBS, MD (Cardiology) - AIIMS New Delhi',
      hospital: 'Apollo Heart Centre, New Delhi',
      consultationFee: 700,
      rating: 4.9,
      reviewCount: 342,
      imageUrl: 'https://images.unsplash.com/photo-1594824813628-984e7cf7dc2d?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      timeSlots: ['10:00 AM', '11:30 AM', '02:00 PM', '04:30 PM', '06:00 PM'],
      about: 'Dr. Priya Sharma is a renowned Senior Interventional Cardiologist with over 8 years of clinical expertise specializing in preventive cardiology, hypertension management, and echocardiography.',
    },
    {
      slug: 'dr-rajesh-verma',
      name: 'Dr. Rajesh Verma',
      specialty: 'Nephrologist',
      specialtySlug: 'nephrology',
      experienceYrs: 10,
      qualification: 'MBBS, MD, DM (Nephrology)',
      hospital: 'Max Super Speciality Hospital, Gurugram',
      consultationFee: 800,
      rating: 4.8,
      reviewCount: 289,
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      timeSlots: ['09:30 AM', '11:00 AM', '03:00 PM', '05:30 PM'],
      about: 'Dr. Rajesh Verma is an expert in chronic kidney disease (CKD), dialysis management, renal transplantation follow-up, and diabetic kidney health.',
    },
    {
      slug: 'dr-ananya-iyer',
      name: 'Dr. Ananya Iyer',
      specialty: 'Endocrinologist & Diabetologist',
      specialtySlug: 'diabetes',
      experienceYrs: 7,
      qualification: 'MBBS, DNB (Endocrinology)',
      hospital: 'Fortis Healthcare, Noida',
      consultationFee: 650,
      rating: 4.9,
      reviewCount: 412,
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Tuesday', 'Thursday', 'Saturday', 'Sunday'],
      timeSlots: ['10:00 AM', '12:00 PM', '04:00 PM', '06:30 PM'],
      about: 'Dr. Ananya Iyer specializes in precision diabetes management, thyroid disorders (PCOS/PCOD), metabolic syndromes, and pediatric hormonal balances.',
    },
    {
      slug: 'dr-amit-patel',
      name: 'Dr. Amit Patel',
      specialty: 'Gastroenterologist',
      specialtySlug: 'gastroenterology',
      experienceYrs: 9,
      qualification: 'MBBS, MD, DM (Gastroenterology)',
      hospital: 'Medanta - The Medicity, Gurugram',
      consultationFee: 750,
      rating: 4.8,
      reviewCount: 215,
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      timeSlots: ['11:00 AM', '01:30 PM', '04:00 PM', '07:00 PM'],
      about: 'Dr. Amit Patel is an expert in digestive health, liver diseases (fatty liver, hepatitis), IBS, endoscopy, and inflammatory bowel diseases.',
    },
    {
      slug: 'dr-sneha-reddy',
      name: 'Dr. Sneha Reddy',
      specialty: 'Neurologist',
      specialtySlug: 'neurology',
      experienceYrs: 11,
      qualification: 'MBBS, MD, DM (Neurology)',
      hospital: 'Manipal Hospital, Bangalore & Tele-Clinic',
      consultationFee: 900,
      rating: 4.9,
      reviewCount: 378,
      imageUrl: 'https://images.unsplash.com/photo-1594824813628-984e7cf7dc2d?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Monday', 'Wednesday', 'Thursday', 'Saturday'],
      timeSlots: ['10:00 AM', '12:30 PM', '03:30 PM', '05:30 PM'],
      about: 'Dr. Sneha Reddy is an acclaimed Neurologist treating migraine, epilepsy, stroke rehabilitation, sleep disorders, and peripheral nerve conditions.',
    },
    {
      slug: 'dr-vikram-malhotra',
      name: 'Dr. Vikram Malhotra',
      specialty: 'General Physician & Internal Medicine',
      specialtySlug: 'general-medicine',
      experienceYrs: 12,
      qualification: 'MBBS, MD (Internal Medicine)',
      hospital: 'Artemis Hospital, Gurugram',
      consultationFee: 500,
      rating: 4.8,
      reviewCount: 512,
      imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=300&auto=format&fit=crop&q=80',
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      timeSlots: ['09:00 AM', '11:00 AM', '02:00 PM', '05:00 PM', '07:00 PM'],
      about: 'Dr. Vikram Malhotra is a trusted family physician with extensive expertise in viral fevers, seasonal infections, preventive lifestyle guidance, and geriatric wellness.',
    },
  ];

  for (const doc of doctors) {
    await prisma.doctor.create({ data: doc });
  }

  console.log('⭐ Seeding Reviews...');
  await prisma.review.createMany({
    data: [
      {
        author: 'Pankaj Malik',
        rating: 5,
        location: 'New Delhi',
        comment: 'I had a great experience with Pathogo! It was so easy to compare different labs and select the most suitable one. The phlebotomist arrived right on time in full protective gear. Will always recommend Pathogo to friends and family!',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
      },
      {
        author: 'Manav Goel',
        rating: 5,
        location: 'Gurugram',
        comment: 'Did you know the Pathogo platform has instant smart package recommendations? All I had to do was choose my age and requirements, and within 12 hours the certified reports were delivered to my phone with complete clarity.',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
      },
      {
        author: 'Paarth Khanna',
        rating: 5,
        location: 'Noida',
        comment: 'Pathogo has made it so easy for me to track my health results. I had low levels of Vitamin D and over the last 6 months have been easily able to monitor my recovery with their trend charts. Exceptional service and smooth booking!',
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80',
      },
    ],
  });

  console.log('📋 Creating initial demonstration booking...');
  const corpPkg = await prisma.healthPackage.findUnique({ where: { slug: 'corporate-health-package' } });
  if (corpPkg) {
    const booking = await prisma.testBooking.create({
      data: {
        bookingNumber: 'PTG-2026-9812',
        userId: demoUser1.id,
        patientName: 'Aarav Mehta',
        patientEmail: 'aarav.mehta@example.com',
        patientPhone: '9876543210',
        patientAge: 32,
        patientGender: Gender.MALE,
        collectionType: CollectionType.HOME_COLLECTION,
        address: 'Flat 402, Sunshine Heights, Sector 45',
        city: 'Gurugram',
        pincode: '122003',
        scheduledDate: new Date('2026-09-24T08:30:00Z'),
        scheduledSlot: '08:00 AM - 09:00 AM',
        couponCode: 'FLEBO2050',
        discountAmount: 249.8,
        totalAmount: 999.2,
        status: BookingStatus.CONFIRMED,
        notes: 'Fasting sample collection required.',
        items: {
          create: [
            {
              packageId: corpPkg.id,
              unitPrice: corpPkg.discountPrice,
              quantity: 1,
            },
          ],
        },
      },
    });
    console.log(`✅ Demo booking created: ${booking.bookingNumber}`);
  }

  console.log('✨ Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
