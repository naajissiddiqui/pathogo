import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/package_model.dart';
import '../models/doctor_model.dart';
import '../models/test_model.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/lab_partners_section.dart';
import '../widgets/packages_section.dart';
import '../widgets/offer_banners_section.dart';
import '../widgets/tests_category_section.dart';
import '../widgets/vitals_section.dart';
import '../widgets/specialists_section.dart';
import '../widgets/media_coverage_section.dart';
import '../widgets/app_promo_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/book_test_dialog.dart';
import '../widgets/book_appointment_dialog.dart';
import '../widgets/doctor_details_dialog.dart';
import '../widgets/view_reports_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  
  final GlobalKey _packagesKey = GlobalKey();
  final GlobalKey _testsKey = GlobalKey();
  final GlobalKey _doctorsKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openBookTestModal({HealthPackage? pkg, LabTest? test}) {
    showDialog(
      context: context,
      builder: (ctx) => BookTestDialog(
        preselectedPackage: pkg,
        preselectedTest: test,
      ),
    );
  }

  void _openBookAppointmentModal(Doctor doctor) {
    showDialog(
      context: context,
      builder: (ctx) => BookAppointmentDialog(doctor: doctor),
    );
  }

  void _openDoctorDetailsModal(Doctor doctor) {
    showDialog(
      context: context,
      builder: (ctx) => DoctorDetailsDialog(
        doctor: doctor,
        onBookAppointment: () => _openBookAppointmentModal(doctor),
      ),
    );
  }

  void _openReportsModal() {
    showDialog(
      context: context,
      builder: (ctx) => const ViewReportsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: _buildMobileDrawer(),
      body: Column(
        children: [
          
          Navbar(
            onBookTestPressed: () => _openBookTestModal(),
            onPackagesPressed: () => _scrollToKey(_packagesKey),
            onTestsPressed: () => _scrollToKey(_testsKey),
            onDoctorsPressed: () => _scrollToKey(_doctorsKey),
            onViewReportsPressed: _openReportsModal,
          ),

          
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  
                  HeroSection(
                    onBookTestPressed: () => _openBookTestModal(),
                    onViewPackagesPressed: () => _scrollToKey(_packagesKey),
                    onViewReportsPressed: _openReportsModal,
                  ),

                  
                  const LabPartnersSection(),

                  
                  Container(
                    key: _packagesKey,
                    child: PackagesSection(
                      onSelectPackage: (pkg) => _openBookTestModal(pkg: pkg),
                    ),
                  ),

                  
                  OfferBannersSection(
                    onApplyCoupon: (code) {
                      _openBookTestModal();
                    },
                  ),

                  
                  Container(
                    key: _testsKey,
                    child: TestsCategorySection(
                      onSelectCategory: (catSlug) {
                        _scrollToKey(_packagesKey);
                      },
                    ),
                  ),

                  
                  VitalsSection(
                    onSelectVital: (title) {
                      _openBookTestModal();
                    },
                  ),

                  
                  Container(
                    key: _doctorsKey,
                    child: SpecialistsSection(
                      onViewDoctorDetails: _openDoctorDetailsModal,
                      onBookDoctorAppointment: _openBookAppointmentModal,
                    ),
                  ),

                  
                  MediaCoverageSection(
                    onConsultNow: () => _scrollToKey(_doctorsKey),
                  ),

                  
                  AppPromoSection(
                    onApplyCoupon: (code) {
                      _openBookTestModal();
                    },
                  ),

                  
                  const ReviewsSection(),

                  
                  const NewsletterSection(),

                  
                  FooterSection(
                    onBookHomeCollection: () => _openBookTestModal(),
                    onPackagesClicked: () => _scrollToKey(_packagesKey),
                    onBookingsClicked: _openReportsModal,
                    onReportsClicked: _openReportsModal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBookTestModal(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.biotech_rounded),
        label: const Text('Book Test', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  
  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pathogo',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home_rounded, color: AppColors.primary),
              title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.biotech_rounded, color: AppColors.secondary),
              title: const Text('Health Packages', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_packagesKey);
              },
            ),
            ListTile(
              leading: const Icon(Icons.science_rounded, color: AppColors.secondary),
              title: const Text('Health Tests', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_testsKey);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services_rounded, color: AppColors.secondary),
              title: const Text('Disease Specialists', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_doctorsKey);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_rounded, color: AppColors.secondary),
              title: const Text('My Bookings & Reports', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.of(context).pop();
                _openReportsModal();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openBookTestModal();
                  },
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Book a Test Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
