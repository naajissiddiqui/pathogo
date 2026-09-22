import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/package_model.dart';
import '../models/test_model.dart';
import '../models/doctor_model.dart';
import '../models/booking_model.dart';
import '../models/appointment_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
    if (token != null && token.isNotEmpty) {
      _headers['Authorization'] = 'Bearer $token';
    } else {
      _headers.remove('Authorization');
    }
  }

  String? get authToken => _authToken;

  
  Future<dynamic> _get(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: _headers).timeout(ApiConfig.timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API GET Error on $url: $e');
      rethrow;
    }
  }

  
  Future<dynamic> _post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(body))
          .timeout(ApiConfig.timeout);
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      } else {
        final msg = decoded is Map<String, dynamic> ? decoded['message'] : 'Failed request';
        throw Exception(msg ?? 'Server error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API POST Error on $url: $e');
      rethrow;
    }
  }

  
  Future<List<PackageCategory>> getPackageCategories() async {
    try {
      final data = await _get(ApiConfig.packageCategories);
      if (data is List) {
        return data.map((json) => PackageCategory.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback package categories: $e');
    }
    return [
      PackageCategory(id: '1', slug: 'all', name: 'All'),
      PackageCategory(id: '2', slug: 'basic', name: 'Basic'),
      PackageCategory(id: '3', slug: 'advance', name: 'Advance'),
      PackageCategory(id: '4', slug: 'women', name: 'Women'),
      PackageCategory(id: '5', slug: 'men', name: 'Men'),
      PackageCategory(id: '6', slug: 'kids', name: 'Kids'),
      PackageCategory(id: '7', slug: 'couple', name: 'Couple'),
      PackageCategory(id: '8', slug: 'corporate', name: 'Corporate'),
    ];
  }

  
  Future<List<HealthPackage>> getPackages({String? category, String? search, bool? popular}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (popular == true) queryParams['popular'] = 'true';

      final uri = Uri.parse(ApiConfig.packages).replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final data = await _get(uri.toString());
      if (data is List) {
        return data.map((json) => HealthPackage.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback packages: $e');
    }
    return _getFallbackPackages(category: category);
  }

  
  Future<List<TestCategory>> getTestCategories() async {
    try {
      final data = await _get(ApiConfig.testCategories);
      if (data is List) {
        return data.map((json) => TestCategory.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback test categories: $e');
    }
    return [
      TestCategory(id: '1', slug: 'bone', name: 'Bone', iconName: 'bone', testsCount: 8),
      TestCategory(id: '2', slug: 'diabetes', name: 'Diabetes', iconName: 'activity', testsCount: 12),
      TestCategory(id: '3', slug: 'gastro', name: 'Gastro', iconName: 'utensils', testsCount: 10),
      TestCategory(id: '4', slug: 'gynae', name: 'Gynae', iconName: 'user-check', testsCount: 14),
      TestCategory(id: '5', slug: 'heart', name: 'Heart', iconName: 'heart', testsCount: 16),
      TestCategory(id: '6', slug: 'kidney', name: 'Kidney', iconName: 'droplet', testsCount: 9),
      TestCategory(id: '7', slug: 'liver', name: 'Liver', iconName: 'shield', testsCount: 11),
      TestCategory(id: '8', slug: 'prostate', name: 'Prostate', iconName: 'user', testsCount: 6),
      TestCategory(id: '9', slug: 'thyroid', name: 'Thyroid', iconName: 'zap', testsCount: 7),
    ];
  }

  
  Future<List<LabTest>> getLabTests({String? category, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse(ApiConfig.tests).replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final data = await _get(uri.toString());
      if (data is List) {
        return data.map((json) => LabTest.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback lab tests: $e');
    }
    return _getFallbackTests(category: category);
  }

  
  Future<List<Doctor>> getDoctors({String? specialty, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (specialty != null && specialty != 'all') queryParams['specialty'] = specialty;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse(ApiConfig.doctors).replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final data = await _get(uri.toString());
      if (data is List) {
        return data.map((json) => Doctor.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback doctors: $e');
    }
    return _getFallbackDoctors(specialty: specialty);
  }

  
  Future<TestBooking> createBooking(Map<String, dynamic> bookingData) async {
    final data = await _post(ApiConfig.bookings, bookingData);
    return TestBooking.fromJson(data);
  }

  
  Future<DoctorAppointment> createAppointment(Map<String, dynamic> appointmentData) async {
    final data = await _post(ApiConfig.appointments, appointmentData);
    return DoctorAppointment.fromJson(data);
  }

  
  Future<List<TestBooking>> lookupBookings(String query) async {
    try {
      final clean = query.trim();
      if (clean.toUpperCase().startsWith('PTG-')) {
        final data = await _get('${ApiConfig.bookings}/$clean');
        return [TestBooking.fromJson(data)];
      } else {
        final data = await _get('${ApiConfig.bookingsLookup}?phone=$clean');
        if (data is List) {
          return data.map((json) => TestBooking.fromJson(json)).toList();
        }
      }
    } catch (e) {
      debugPrint('Lookup error: $e');
    }
    return [];
  }

  
  Future<List<DoctorAppointment>> lookupAppointments(String phone) async {
    try {
      final data = await _get('${ApiConfig.appointmentsLookup}?phone=${phone.trim()}');
      if (data is List) {
        return data.map((json) => DoctorAppointment.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Appointment lookup error: $e');
    }
    return [];
  }

  
  Future<List<Review>> getReviews() async {
    try {
      final data = await _get(ApiConfig.reviews);
      if (data is List) {
        return data.map((json) => Review.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Using fallback reviews: $e');
    }
    return [
      Review(
        id: '1',
        author: 'Pankaj Malik',
        rating: 5,
        location: 'New Delhi',
        comment: 'I had a great experience with Pathogo! It was so easy to compare different labs and select the most suitable one. After this experience, I will always recommend Pathogo to my friends and family whenever they need to book a healthcare test.',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
      ),
      Review(
        id: '2',
        author: 'Manav Goel',
        rating: 5,
        location: 'Gurugram',
        comment: 'Did you know the Pathogo platform has instant smart package recommendations? All I had to do was choose my age and requirements, and within 12 hours the certified reports were delivered to my phone with complete clarity.',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
      ),
      Review(
        id: '3',
        author: 'Paarth Khanna',
        rating: 5,
        location: 'Noida',
        comment: 'Pathogo has made it so easy for me to track my health results. I had low levels of Vitamin D and over the last 6 months have been easily able to monitor my recovery with their trend charts. Exceptional service and smooth booking!',
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80',
      ),
    ];
  }

  
  Future<String> subscribeNewsletter(String email) async {
    await _post(ApiConfig.newsletter, {'email': email});
    return 'Subscribed successfully';
  }

  
  List<HealthPackage> _getFallbackPackages({String? category}) {
    final all = [
      HealthPackage(
        id: 'pkg-1',
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
      ),
      HealthPackage(
        id: 'pkg-2',
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
      ),
      HealthPackage(
        id: 'pkg-3',
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
      ),
      HealthPackage(
        id: 'pkg-4',
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
      ),
      HealthPackage(
        id: 'pkg-5',
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
      ),
      HealthPackage(
        id: 'pkg-6',
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
      ),
      HealthPackage(
        id: 'pkg-7',
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
      ),
      HealthPackage(
        id: 'pkg-8',
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
      ),
      HealthPackage(
        id: 'pkg-9',
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
      ),
    ];

    if (category != null && category != 'all') {
      return all.where((p) => p.categorySlug == category).toList();
    }
    return all;
  }

  List<LabTest> _getFallbackTests({String? category}) {
    final tests = [
      LabTest(
        id: 't-1',
        slug: 'complete-blood-count',
        name: 'Complete Blood Count (CBC)',
        code: 'CBC-01',
        categorySlug: 'bone',
        price: 299,
        originalPrice: 450,
        description: 'Measures red blood cells, white blood cells, hemoglobin, hematocrit, and platelets.',
        fastingRequired: false,
        reportTimeHours: 12,
      ),
      LabTest(
        id: 't-2',
        slug: 'hba1c-glycated-hemoglobin',
        name: 'Glycosylated Hemoglobin (HbA1c)',
        code: 'HBA-02',
        categorySlug: 'diabetes',
        price: 399,
        originalPrice: 600,
        description: 'Measures 3-month average blood sugar control for diabetic monitoring and diagnosis.',
        fastingRequired: false,
        reportTimeHours: 12,
      ),
      LabTest(
        id: 't-3',
        slug: 'lipid-profile-heart-risk',
        name: 'Lipid Profile (Heart Risk)',
        code: 'LPD-03',
        categorySlug: 'heart',
        price: 499,
        originalPrice: 750,
        description: 'Assesses total cholesterol, HDL, LDL, VLDL, and triglycerides to evaluate cardiovascular risk.',
        fastingRequired: true,
        reportTimeHours: 24,
      ),
      LabTest(
        id: 't-4',
        slug: 'liver-function-test',
        name: 'Liver Function Test (LFT) Basic',
        code: 'LFT-04',
        categorySlug: 'liver',
        price: 450,
        originalPrice: 700,
        description: 'Measures SGOT, SGPT, Bilirubin, Alkaline Phosphatase, and Albumin to assess liver function.',
        fastingRequired: true,
        reportTimeHours: 24,
      ),
      LabTest(
        id: 't-5',
        slug: 'kidney-function-test',
        name: 'Kidney Function Test (KFT / RFT)',
        code: 'KFT-05',
        categorySlug: 'kidney',
        price: 450,
        originalPrice: 700,
        description: 'Measures Urea, Blood Urea Nitrogen (BUN), Creatinine, and Uric Acid to assess kidney filtration.',
        fastingRequired: false,
        reportTimeHours: 24,
      ),
      LabTest(
        id: 't-6',
        slug: 'thyroid-profile-total',
        name: 'Thyroid Profile Total (T3, T4, TSH)',
        code: 'THY-06',
        categorySlug: 'thyroid',
        price: 350,
        originalPrice: 550,
        description: 'Comprehensive screening for hyperthyroidism and hypothyroidism hormone levels.',
        fastingRequired: true,
        reportTimeHours: 24,
      ),
      LabTest(
        id: 't-7',
        slug: 'vitamin-d-25-hydroxy',
        name: 'Vitamin D 25-Hydroxy',
        code: 'VIT-07',
        categorySlug: 'bone',
        price: 699,
        originalPrice: 1200,
        description: 'Essential for bone health, immune function, and calcium absorption analysis.',
        fastingRequired: false,
        reportTimeHours: 24,
      ),
      LabTest(
        id: 't-8',
        slug: 'psa-prostate-specific-antigen',
        name: 'Prostate Specific Antigen (PSA)',
        code: 'PSA-09',
        categorySlug: 'prostate',
        price: 550,
        originalPrice: 900,
        description: 'Screening marker for prostate health, enlargement, or prostate inflammation in men.',
        fastingRequired: false,
        reportTimeHours: 24,
      ),
    ];
    if (category != null && category != 'all') {
      return tests.where((t) => t.categorySlug == category).toList();
    }
    return tests;
  }

  List<Doctor> _getFallbackDoctors({String? specialty}) {
    final doctors = [
      Doctor(
        id: 'doc-1',
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
      ),
      Doctor(
        id: 'doc-2',
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
      ),
      Doctor(
        id: 'doc-3',
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
      ),
      Doctor(
        id: 'doc-4',
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
      ),
    ];
    if (specialty != null && specialty != 'all') {
      return doctors.where((d) => d.specialtySlug == specialty).toList();
    }
    return doctors;
  }

  
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? gender,
    int? age,
    String? city,
    String? address,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
    if (gender != null) body['gender'] = gender;
    if (age != null) body['age'] = age;
    if (city != null) body['city'] = city;
    if (address != null) body['address'] = address;

    final data = await _post(ApiConfig.authRegister, body);
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      final userJson = data['user'] as Map<String, dynamic>? ?? data;
      setAuthToken(token);
      return UserModel.fromJson(userJson, token: token);
    }
    throw Exception('Invalid server response format');
  }

  
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };

    final data = await _post(ApiConfig.authLogin, body);
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      final userJson = data['user'] as Map<String, dynamic>? ?? data;
      setAuthToken(token);
      return UserModel.fromJson(userJson, token: token);
    }
    throw Exception('Invalid server response format');
  }

  
  Future<UserModel> getProfile() async {
    final data = await _get(ApiConfig.authMe);
    if (data is Map<String, dynamic>) {
      return UserModel.fromJson(data, token: _authToken);
    }
    throw Exception('Failed to fetch user profile');
  }

  
  Future<List<UserModel>> getUsers({String? search}) async {
    final query = search != null && search.isNotEmpty ? '?search=${Uri.encodeComponent(search)}' : '';
    final data = await _get('${ApiConfig.users}$query');
    if (data is List) {
      return data.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }
}
