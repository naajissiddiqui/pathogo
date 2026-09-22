import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/doctor_model.dart';
import '../providers/app_state_provider.dart';
import 'doctor_card.dart';

class SpecialistsSection extends StatelessWidget {
  final Function(Doctor) onViewDoctorDetails;
  final Function(Doctor) onBookDoctorAppointment;

  const SpecialistsSection({
    super.key,
    required this.onViewDoctorDetails,
    required this.onBookDoctorAppointment,
  });

  static const List<Map<String, dynamic>> specialties = [
    {'slug': 'all', 'name': 'All Specialists', 'icon': Icons.medical_information_rounded, 'color': Color(0xFFE11D74)},
    {'slug': 'cardiology', 'name': 'Cardiology', 'icon': Icons.favorite_rounded, 'color': Color(0xFFDC2626)},
    {'slug': 'nephrology', 'name': 'Nephrology', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0284C7)},
    {'slug': 'diabetes', 'name': 'Diabetes / Endo', 'icon': Icons.show_chart_rounded, 'color': Color(0xFFF59E0B)},
    {'slug': 'gastroenterology', 'name': 'Gastroenterology', 'icon': Icons.restaurant_rounded, 'color': Color(0xFFF97316)},
    {'slug': 'neurology', 'name': 'Neurology', 'icon': Icons.psychology_rounded, 'color': Color(0xFF7C3AED)},
    {'slug': 'general-medicine', 'name': 'General Medicine', 'icon': Icons.health_and_safety_rounded, 'color': Color(0xFF059669)},
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
                'Disease Specialists',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3A8A), 
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: specialties.map((spec) {
                    final isSelected = state.selectedDoctorSpecialty == spec['slug'];
                    final color = spec['color'] as Color;

                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: InkWell(
                        onTap: () => state.setDoctorSpecialty(spec['slug']),
                        borderRadius: BorderRadius.circular(30),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E1B4B) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1E1B4B) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  spec['icon'] as IconData,
                                  size: 14,
                                  color: isSelected ? Colors.white : color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                spec['name'] as String,
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 26),

              
              if (state.isLoadingDoctors)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                  ),
                )
              else if (state.doctors.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No doctors found for this specialty.', style: TextStyle(color: Color(0xFF64748B))),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.doctors.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 300,
                          height: 260,
                          child: DoctorCard(
                            doctor: doc,
                            onViewDetails: () => onViewDoctorDetails(doc),
                            onBookAppointment: () => onBookDoctorAppointment(doc),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
