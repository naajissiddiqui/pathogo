import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/booking_model.dart';
import '../models/appointment_model.dart';
import '../providers/app_state_provider.dart';

class ViewReportsDialog extends StatefulWidget {
  const ViewReportsDialog({super.key});

  @override
  State<ViewReportsDialog> createState() => _ViewReportsDialogState();
}

class _ViewReportsDialogState extends State<ViewReportsDialog> {
  final TextEditingController _searchController = TextEditingController(text: '9876543210');
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performLookup();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performLookup() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _hasSearched = true);
    final state = Provider.of<AppStateProvider>(context, listen: false);
    await state.lookupHistory(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 680,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.file_download_outlined, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'My Bookings & Lab Reports',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            'Search by mobile number or booking tracking ID',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Phone (e.g. 9876543210) or Booking ID (PTG-...)',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (_) => _performLookup(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: state.isLookupLoading ? null : _performLookup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: state.isLookupLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              Expanded(
                child: state.isLookupLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _buildResultsList(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(AppStateProvider state) {
    if (!_hasSearched) {
      return const Center(
        child: Text('Enter your phone number or booking number to view records.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    if (state.userBookings.isEmpty && state.userAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('No active bookings or appointments found for this query.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (state.userBookings.isNotEmpty) ...[
          const Text(
            'Diagnostic Test Bookings',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.secondary),
          ),
          const SizedBox(height: 10),
          ...state.userBookings.map((b) => _buildBookingCard(b)),
          const SizedBox(height: 16),
        ],
        if (state.userAppointments.isNotEmpty) ...[
          const Text(
            'Doctor Consultations',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.secondary),
          ),
          const SizedBox(height: 10),
          ...state.userAppointments.map((a) => _buildAppointmentCard(a)),
        ],
      ],
    );
  }

  Widget _buildBookingCard(TestBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.biotech_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    booking.bookingNumber,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.secondary),
                  ),
                ],
              ),
              _buildStatusPill(booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Patient: ${booking.patientName} (${booking.patientAge} yrs, ${booking.patientGender})',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Slot: ${DateFormat('dd MMM yyyy').format(DateTime.tryParse(booking.scheduledDate) ?? DateTime.now())} • ${booking.scheduledSlot}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Collection: ${booking.collectionType == 'HOME_COLLECTION' ? '🏠 Home Collection' : '🏥 Lab Visit'}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid: ₹${booking.totalAmount.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.secondary),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _showSampleReportDialog(booking);
                },
                icon: const Icon(Icons.download_rounded, size: 14),
                label: const Text('View / Download Report', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(DoctorAppointment apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.video_call_rounded, size: 16, color: Color(0xFF2563EB)),
                  const SizedBox(width: 6),
                  Text(
                    apt.appointmentNumber,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.secondary),
                  ),
                ],
              ),
              _buildStatusPill(apt.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Doctor: ${apt.doctor?.name ?? 'Specialist'}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Patient: ${apt.patientName} • Fee: ₹${apt.consultationFee.toInt()}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Time: ${DateFormat('dd MMM yyyy').format(DateTime.tryParse(apt.appointmentDate) ?? DateTime.now())} • ${apt.appointmentSlot}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = AppColors.successLight;
    Color fg = AppColors.success;

    if (status == 'PENDING') {
      bg = AppColors.warningLight;
      fg = AppColors.warning;
    } else if (status == 'CANCELLED') {
      bg = AppColors.errorLight;
      fg = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }

  void _showSampleReportDialog(TestBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.verified_rounded, color: AppColors.success),
            SizedBox(width: 8),
            Text('Verified Lab Report Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lab Partner: MAX Healthcare Diagnostics', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Patient: ${booking.patientName}', style: const TextStyle(fontSize: 12)),
            Text('Booking Reference: ${booking.bookingNumber}', style: const TextStyle(fontSize: 12)),
            const Divider(height: 18),
            const Text('TEST RESULTS SUMMARY:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            _ReportRow(test: 'Hemoglobin (Hb)', result: '14.2 g/dL', normal: '13.0 - 17.0', status: 'NORMAL'),
            _ReportRow(test: 'Blood Glucose Fasting', result: '92 mg/dL', normal: '70 - 100', status: 'NORMAL'),
            _ReportRow(test: 'Total Cholesterol', result: '175 mg/dL', normal: '< 200', status: 'NORMAL'),
            _ReportRow(test: 'Vitamin D 25-Hydroxy', result: '38.4 ng/mL', normal: '30 - 100', status: 'NORMAL'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading verified PDF report for ${booking.bookingNumber}...'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            icon: const Icon(Icons.file_download_outlined, size: 16),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String test;
  final String result;
  final String normal;
  final String status;

  const _ReportRow({
    required this.test,
    required this.result,
    required this.normal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(test, style: const TextStyle(fontSize: 11)),
          Text('$result ($status)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
        ],
      ),
    );
  }
}
