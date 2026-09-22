import 'package:flutter/material.dart';
import '../models/package_model.dart';
import '../models/test_model.dart';
import '../models/doctor_model.dart';
import '../models/booking_model.dart';
import '../models/appointment_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AppStateProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  
  UserModel? _currentUser;
  bool _isAuthLoading = false;
  String? _authError;

  
  List<PackageCategory> _packageCategories = [];
  List<HealthPackage> _packages = [];
  String _selectedPackageCategory = 'all';
  bool _isLoadingPackages = false;
  String? _packagesError;

  
  List<TestCategory> _testCategories = [];
  List<LabTest> _tests = [];
  String _selectedTestCategory = 'all';
  bool _isLoadingTests = false;

  
  List<Doctor> _doctors = [];
  String _selectedDoctorSpecialty = 'all';
  bool _isLoadingDoctors = false;

  
  List<Review> _reviews = [];
  bool _isLoadingReviews = false;

  
  List<TestBooking> _userBookings = [];
  List<DoctorAppointment> _userAppointments = [];
  bool _isLookupLoading = false;

  
  String _searchQuery = '';

  
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAuthLoading => _isAuthLoading;
  String? get authError => _authError;

  
  List<PackageCategory> get packageCategories => _packageCategories;
  List<HealthPackage> get packages => _packages;
  String get selectedPackageCategory => _selectedPackageCategory;
  bool get isLoadingPackages => _isLoadingPackages;
  String? get packagesError => _packagesError;

  List<TestCategory> get testCategories => _testCategories;
  List<LabTest> get tests => _tests;
  String get selectedTestCategory => _selectedTestCategory;
  bool get isLoadingTests => _isLoadingTests;

  List<Doctor> get doctors => _doctors;
  String get selectedDoctorSpecialty => _selectedDoctorSpecialty;
  bool get isLoadingDoctors => _isLoadingDoctors;

  List<Review> get reviews => _reviews;
  bool get isLoadingReviews => _isLoadingReviews;

  List<TestBooking> get userBookings => _userBookings;
  List<DoctorAppointment> get userAppointments => _userAppointments;
  bool get isLookupLoading => _isLookupLoading;
  String get searchQuery => _searchQuery;

  AppStateProvider() {
    initData();
  }

  Future<void> initData() async {
    await Future.wait([
      fetchPackageCategories(),
      fetchPackages(),
      fetchTestCategories(),
      fetchLabTests(),
      fetchDoctors(),
      fetchReviews(),
    ]);
  }

  
  void setPackageCategory(String slug) {
    if (_selectedPackageCategory != slug) {
      _selectedPackageCategory = slug;
      notifyListeners();
      fetchPackages();
    }
  }

  
  void setDoctorSpecialty(String specialtySlug) {
    if (_selectedDoctorSpecialty != specialtySlug) {
      _selectedDoctorSpecialty = specialtySlug;
      notifyListeners();
      fetchDoctors();
    }
  }

  
  void setTestCategory(String categorySlug) {
    if (_selectedTestCategory != categorySlug) {
      _selectedTestCategory = categorySlug;
      notifyListeners();
      fetchLabTests();
    }
  }

  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
    fetchPackages();
    fetchLabTests();
    fetchDoctors();
  }

  
  Future<void> fetchPackageCategories() async {
    try {
      _packageCategories = await _apiService.getPackageCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching package categories: $e');
    }
  }

  
  Future<void> fetchPackages() async {
    _isLoadingPackages = true;
    _packagesError = null;
    notifyListeners();

    try {
      _packages = await _apiService.getPackages(
        category: _selectedPackageCategory,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
    } catch (e) {
      _packagesError = e.toString();
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }

  
  Future<void> fetchTestCategories() async {
    try {
      _testCategories = await _apiService.getTestCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching test categories: $e');
    }
  }

  
  Future<void> fetchLabTests() async {
    _isLoadingTests = true;
    notifyListeners();

    try {
      _tests = await _apiService.getLabTests(
        category: _selectedTestCategory,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
    } catch (e) {
      debugPrint('Error fetching lab tests: $e');
    } finally {
      _isLoadingTests = false;
      notifyListeners();
    }
  }

  
  Future<void> fetchDoctors() async {
    _isLoadingDoctors = true;
    notifyListeners();

    try {
      _doctors = await _apiService.getDoctors(
        specialty: _selectedDoctorSpecialty,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
    } catch (e) {
      debugPrint('Error fetching doctors: $e');
    } finally {
      _isLoadingDoctors = false;
      notifyListeners();
    }
  }

  
  Future<void> fetchReviews() async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _reviews = await _apiService.getReviews();
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  
  Future<TestBooking> createBooking(Map<String, dynamic> bookingData) async {
    final booking = await _apiService.createBooking(bookingData);
    _userBookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  
  Future<DoctorAppointment> createAppointment(Map<String, dynamic> appointmentData) async {
    final appointment = await _apiService.createAppointment(appointmentData);
    _userAppointments.insert(0, appointment);
    notifyListeners();
    return appointment;
  }

  
  Future<void> lookupHistory(String query) async {
    _isLookupLoading = true;
    notifyListeners();

    try {
      final results = await _apiService.lookupBookings(query);
      _userBookings = results;

      if (!query.toUpperCase().startsWith('PTG-')) {
        final apts = await _apiService.lookupAppointments(query);
        _userAppointments = apts;
      }
    } catch (e) {
      debugPrint('Error looking up bookings: $e');
    } finally {
      _isLookupLoading = false;
      notifyListeners();
    }
  }

  
  Future<String> subscribeNewsletter(String email) async {
    return _apiService.subscribeNewsletter(email);
  }

  
  Future<bool> login(String email, String password) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email: email, password: password);
      _currentUser = user;
      _isAuthLoading = false;
      notifyListeners();
      
      
      if (user.phone.isNotEmpty) {
        lookupHistory(user.phone);
      }
      return true;
    } catch (e) {
      _isAuthLoading = false;
      _authError = e.toString().replaceAll('Exception:', '').trim();
      notifyListeners();
      return false;
    }
  }

  
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? gender,
    int? age,
    String? city,
    String? address,
  }) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final user = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        gender: gender,
        age: age,
        city: city,
        address: address,
      );
      _currentUser = user;
      _isAuthLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isAuthLoading = false;
      _authError = e.toString().replaceAll('Exception:', '').trim();
      notifyListeners();
      return false;
    }
  }

  
  void logout() {
    _currentUser = null;
    _apiService.setAuthToken(null);
    _userBookings.clear();
    _userAppointments.clear();
    notifyListeners();
  }
}
