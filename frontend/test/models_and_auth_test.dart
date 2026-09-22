import 'package:flutter_test/flutter_test.dart';
import 'package:pathogo_frontend/models/user_model.dart';
import 'package:pathogo_frontend/models/package_model.dart';
import 'package:pathogo_frontend/models/doctor_model.dart';

void main() {
  group('Models Unit Tests', () {
    test('UserModel serializes and deserializes correctly', () {
      final json = {
        'id': 'usr-1',
        'name': 'Rahul Sharma',
        'email': 'rahul@pathogo.com',
        'phone': '9876543210',
        'gender': 'MALE',
        'age': 30,
        'city': 'Gurugram',
        'address': 'Sector 45',
      };

      final user = UserModel.fromJson(json, token: 'mock_jwt_token_123');
      expect(user.id, 'usr-1');
      expect(user.name, 'Rahul Sharma');
      expect(user.email, 'rahul@pathogo.com');
      expect(user.token, 'mock_jwt_token_123');
      expect(user.age, 30);

      final userMap = user.toJson();
      expect(userMap['email'], 'rahul@pathogo.com');
      expect(userMap['token'], 'mock_jwt_token_123');
    });

    test('HealthPackage calculates discount properly', () {
      final json = {
        'id': 'pkg-1',
        'slug': 'basic-health-package',
        'name': 'Basic Health Package',
        'description': 'Complete blood test',
        'categorySlug': 'basic',
        'originalPrice': 1000.0,
        'discountPrice': 500.0,
        'discountPercent': 50,
        'testCount': 28,
        'isPopular': true,
        'reportTimeHours': 24,
        'fastingRequired': true,
        'includedSummary': ['CBC', 'Lipid'],
      };

      final package = HealthPackage.fromJson(json);
      expect(package.name, 'Basic Health Package');
      expect(package.originalPrice, 1000.0);
      expect(package.discountPrice, 500.0);
      expect(package.discountPercent, 50);
      expect(package.testCount, 28);
    });

    test('Doctor model parsed correctly', () {
      final json = {
        'id': 'doc-1',
        'slug': 'dr-priya-sharma',
        'name': 'Dr. Priya Sharma',
        'specialty': 'Cardiologist',
        'specialtySlug': 'cardiology',
        'experienceYrs': 12,
        'qualification': 'MBBS, MD, DM',
        'hospital': 'Apollo Hospital',
        'consultationFee': 900.0,
        'rating': 4.9,
        'reviewCount': 340,
        'imageUrl': 'https://example.com/img.jpg',
        'availableDays': ['Mon', 'Tue'],
        'timeSlots': ['10:00 AM', '02:00 PM'],
        'about': 'Cardiology specialist',
      };

      final doctor = Doctor.fromJson(json);
      expect(doctor.name, 'Dr. Priya Sharma');
      expect(doctor.specialtySlug, 'cardiology');
      expect(doctor.consultationFee, 900.0);
      expect(doctor.availableDays.length, 2);
    });
  });
}
