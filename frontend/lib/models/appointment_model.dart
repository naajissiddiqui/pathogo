import 'doctor_model.dart';

class DoctorAppointment {
  final String id;
  final String appointmentNumber;
  final String doctorId;
  final Doctor? doctor;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String appointmentDate;
  final String appointmentSlot;
  final String consultationType;
  final String? symptoms;
  final String status;
  final double consultationFee;
  final String createdAt;

  DoctorAppointment({
    required this.id,
    required this.appointmentNumber,
    required this.doctorId,
    this.doctor,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    required this.appointmentDate,
    required this.appointmentSlot,
    required this.consultationType,
    this.symptoms,
    required this.status,
    required this.consultationFee,
    required this.createdAt,
  });

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) {
    return DoctorAppointment(
      id: json['id'] ?? '',
      appointmentNumber: json['appointmentNumber'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      patientName: json['patientName'] ?? '',
      patientEmail: json['patientEmail'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      patientAge: json['patientAge'] ?? 0,
      patientGender: json['patientGender'] ?? 'MALE',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentSlot: json['appointmentSlot'] ?? '',
      consultationType: json['consultationType'] ?? 'VIDEO',
      symptoms: json['symptoms'],
      status: json['status'] ?? 'CONFIRMED',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 500.0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
