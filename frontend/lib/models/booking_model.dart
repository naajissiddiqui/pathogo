import 'package_model.dart';
import 'test_model.dart';

class TestBookingItem {
  final String id;
  final String? packageId;
  final HealthPackage? package;
  final String? testId;
  final LabTest? test;
  final double unitPrice;
  final int quantity;

  TestBookingItem({
    required this.id,
    this.packageId,
    this.package,
    this.testId,
    this.test,
    required this.unitPrice,
    required this.quantity,
  });

  factory TestBookingItem.fromJson(Map<String, dynamic> json) {
    return TestBookingItem(
      id: json['id'] ?? '',
      packageId: json['packageId'],
      package: json['package'] != null ? HealthPackage.fromJson(json['package']) : null,
      testId: json['testId'],
      test: json['test'] != null ? LabTest.fromJson(json['test']) : null,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }
}

class TestBooking {
  final String id;
  final String bookingNumber;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String collectionType;
  final String? address;
  final String? city;
  final String? pincode;
  final String scheduledDate;
  final String scheduledSlot;
  final String? couponCode;
  final double discountAmount;
  final double totalAmount;
  final String status;
  final String? notes;
  final List<TestBookingItem> items;
  final String createdAt;

  TestBooking({
    required this.id,
    required this.bookingNumber,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    required this.collectionType,
    this.address,
    this.city,
    this.pincode,
    required this.scheduledDate,
    required this.scheduledSlot,
    this.couponCode,
    required this.discountAmount,
    required this.totalAmount,
    required this.status,
    this.notes,
    required this.items,
    required this.createdAt,
  });

  factory TestBooking.fromJson(Map<String, dynamic> json) {
    return TestBooking(
      id: json['id'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      patientName: json['patientName'] ?? '',
      patientEmail: json['patientEmail'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      patientAge: json['patientAge'] ?? 0,
      patientGender: json['patientGender'] ?? 'MALE',
      collectionType: json['collectionType'] ?? 'HOME_COLLECTION',
      address: json['address'],
      city: json['city'],
      pincode: json['pincode'],
      scheduledDate: json['scheduledDate'] ?? '',
      scheduledSlot: json['scheduledSlot'] ?? '',
      couponCode: json['couponCode'],
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'CONFIRMED',
      notes: json['notes'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => TestBookingItem.fromJson(i)).toList()
          : [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
