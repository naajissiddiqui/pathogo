import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/package_model.dart';
import '../models/test_model.dart';
import '../models/booking_model.dart';
import '../providers/app_state_provider.dart';

class BookTestDialog extends StatefulWidget {
  final HealthPackage? preselectedPackage;
  final LabTest? preselectedTest;

  const BookTestDialog({
    super.key,
    this.preselectedPackage,
    this.preselectedTest,
  });

  @override
  State<BookTestDialog> createState() => _BookTestDialogState();
}

class _BookTestDialogState extends State<BookTestDialog> {
  final _formKey = GlobalKey<FormState>();

  
  HealthPackage? _selectedPackage;
  LabTest? _selectedTest;

  
  String _collectionType = 'HOME_COLLECTION';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController(text: '30');
  String _gender = 'MALE';
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _couponController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '08:00 AM - 09:00 AM';

  bool _isSubmitting = false;
  TestBooking? _confirmedBooking;
  double _appliedDiscount = 0.0;
  String? _couponMessage;

  final List<String> _timeSlots = [
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '03:00 PM - 04:00 PM',
    '05:00 PM - 06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPackage = widget.preselectedPackage;
    _selectedTest = widget.preselectedTest;

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<AppStateProvider>(context, listen: false);
      if (_selectedPackage == null && _selectedTest == null && state.packages.isNotEmpty) {
        setState(() {
          _selectedPackage = state.packages.first;
        });
      }
      final user = state.currentUser;
      if (user != null) {
        setState(() {
          if (_nameController.text.isEmpty) _nameController.text = user.name;
          if (_emailController.text.isEmpty) _emailController.text = user.email;
          if (_phoneController.text.isEmpty) _phoneController.text = user.phone;
          if (user.age != null) _ageController.text = user.age.toString();
          if (user.gender != null) _gender = user.gender!;
          if (user.address != null && _addressController.text.isEmpty) {
            _addressController.text = user.address!;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _couponController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _subtotal {
    double total = 0.0;
    if (_selectedPackage != null) total += _selectedPackage!.discountPrice;
    if (_selectedTest != null) total += _selectedTest!.price;
    return total;
  }

  double get _totalAmount {
    return (_subtotal - _appliedDiscount).clamp(0.0, double.infinity);
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'FLEBO2050' || code == 'PATHOGO20') {
      setState(() {
        _appliedDiscount = (_subtotal * 0.2).roundToDouble();
        _couponMessage = 'Coupon applied: 20% discount (₹${_appliedDiscount.toInt()})';
      });
    } else if (code.isNotEmpty) {
      setState(() {
        _appliedDiscount = 0.0;
        _couponMessage = 'Invalid coupon code. Try FLEBO2050 for 20% off!';
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPackage == null && _selectedTest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one health package or test')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final state = Provider.of<AppStateProvider>(context, listen: false);

      final bookingPayload = {
        if (state.currentUser != null) 'userId': state.currentUser!.id,
        'patientName': _nameController.text.trim(),
        'patientEmail': _emailController.text.trim(),
        'patientPhone': _phoneController.text.trim(),
        'patientAge': int.tryParse(_ageController.text.trim()) ?? 30,
        'patientGender': _gender,
        'collectionType': _collectionType,
        'address': _collectionType == 'HOME_COLLECTION' ? _addressController.text.trim() : null,
        'city': 'Delhi NCR',
        'pincode': _pincodeController.text.trim(),
        'scheduledDate': _selectedDate.toIso8601String(),
        'scheduledSlot': _selectedSlot,
        'couponCode': _couponController.text.trim().isNotEmpty ? _couponController.text.trim().toUpperCase() : null,
        'notes': _notesController.text.trim(),
        'packageIds': _selectedPackage != null ? [_selectedPackage!.id, _selectedPackage!.slug, _selectedPackage!.name] : [],
        'testIds': _selectedTest != null ? [_selectedTest!.id, _selectedTest!.slug, _selectedTest!.name] : [],
      };

      final booking = await state.createBooking(bookingPayload);
      setState(() {
        _confirmedBooking = booking;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 680,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: _confirmedBooking != null ? _buildSuccessView() : _buildFormView(isDesktop),
      ),
    );
  }

  
  Widget _buildSuccessView() {
    final booking = _confirmedBooking!;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your lab sample collection has been scheduled.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Booking ID:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(
                      booking.bookingNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Patient Name:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(booking.patientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date & Time:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(DateTime.tryParse(booking.scheduledDate) ?? DateTime.now())}, ${booking.scheduledSlot}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Collection Mode:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(
                      booking.collectionType == 'HOME_COLLECTION' ? '🏠 Home Collection' : '🏥 Lab Visit',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount Paid:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    Text(
                      '₹${booking.totalAmount.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Done / View My Bookings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  
  Widget _buildFormView(bool isDesktop) {
    final state = Provider.of<AppStateProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                      child: const Icon(Icons.biotech_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Book a Lab Test / Package',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          'Safe, contactless home sample collection',
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

            
            const Text('Select Health Package', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            DropdownButtonFormField<HealthPackage>(
              value: _selectedPackage,
              isExpanded: true,
              decoration: const InputDecoration(hintText: 'Choose a package'),
              items: state.packages.map((pkg) {
                return DropdownMenuItem(
                  value: pkg,
                  child: Text('${pkg.name} - ₹${pkg.discountPrice.toInt()}', style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedPackage = val;
                  _applyCoupon();
                });
              },
            ),
            const SizedBox(height: 14),

            
            const Text('Collection Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _collectionType = 'HOME_COLLECTION'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: _collectionType == 'HOME_COLLECTION' ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _collectionType == 'HOME_COLLECTION' ? AppColors.primary : AppColors.cardBorder,
                          width: _collectionType == 'HOME_COLLECTION' ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded, size: 16, color: _collectionType == 'HOME_COLLECTION' ? AppColors.primary : AppColors.secondary),
                          const SizedBox(width: 6),
                          Text(
                            'Home Sample Collection',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _collectionType == 'HOME_COLLECTION' ? AppColors.primary : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _collectionType = 'LAB_VISIT'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: _collectionType == 'LAB_VISIT' ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _collectionType == 'LAB_VISIT' ? AppColors.primary : AppColors.cardBorder,
                          width: _collectionType == 'LAB_VISIT' ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_hospital_rounded, size: 16, color: _collectionType == 'LAB_VISIT' ? AppColors.primary : AppColors.secondary),
                          const SizedBox(width: 6),
                          Text(
                            'Visit Partner Lab',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _collectionType == 'LAB_VISIT' ? AppColors.primary : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Name *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(hintText: 'Full Name'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mobile Number *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: '10 digits'),
                        validator: (v) => v == null || v.trim().length < 10 ? 'Enter 10 digits' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email Address *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'email@example.com'),
                        validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Age', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Age'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'MALE', child: Text('Male')),
                          DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                          DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                        ],
                        onChanged: (val) => setState(() => _gender = val ?? 'MALE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            
            if (_collectionType == 'HOME_COLLECTION') ...[
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pickup Address *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(hintText: 'Flat, House No, Street'),
                          validator: (v) => _collectionType == 'HOME_COLLECTION' && (v == null || v.trim().isEmpty)
                              ? 'Address required for home collection'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pincode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '110001'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Scheduled Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.cardBorder),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(fontSize: 13)),
                              const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedSlot,
                        decoration: const InputDecoration(),
                        items: _timeSlots
                            .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedSlot = val ?? _timeSlots.first),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(hintText: 'Enter coupon (e.g. FLEBO2050)'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
            if (_couponMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                _couponMessage!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _appliedDiscount > 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 18),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Payable Amount', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Row(
                        children: [
                          if (_appliedDiscount > 0) ...[
                            Text(
                              '₹${_subtotal.toInt()}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            '₹${_totalAmount.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Confirm Booking →', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
