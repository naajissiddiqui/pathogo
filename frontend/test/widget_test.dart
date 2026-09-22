import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathogo_frontend/models/package_model.dart';
import 'package:pathogo_frontend/models/test_model.dart';
import 'package:pathogo_frontend/widgets/package_card.dart';

void main() {
  testWidgets('PackageCard displays correct discount, test count and price info', (WidgetTester tester) async {
    final pkg = HealthPackage(
      id: 'pkg-test-1',
      slug: 'basic-health-package',
      name: 'Basic Wellness Package',
      description: 'Complete blood count and lipid test',
      categorySlug: 'basic',
      originalPrice: 1200,
      discountPrice: 599,
      discountPercent: 50,
      testCount: 32,
      isPopular: true,
      reportTimeHours: 12,
      fastingRequired: true,
      includedSummary: ['CBC', 'Lipid', 'Liver Profile'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PackageCard(
            package: pkg,
            onBookPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Basic Wellness Package'), findsOneWidget);
    expect(find.text('Test Included: 32'), findsOneWidget);
    expect(find.text('₹599'), findsOneWidget);
    expect(find.text('Most Popular'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('LabTest model and Category model verify correctly', (WidgetTester tester) async {
    final cat = TestCategory(
      id: 'cat-1',
      slug: 'heart',
      name: 'Heart Care',
      iconName: 'favorite',
      testsCount: 14,
    );

    final testItem = LabTest(
      id: 't-1',
      slug: 'lipid-profile',
      name: 'Lipid Profile Screen',
      categorySlug: 'heart',
      price: 499,
      originalPrice: 899,
      description: 'Comprehensive cholesterol screening',
      fastingRequired: true,
      reportTimeHours: 24,
    );

    expect(cat.name, 'Heart Care');
    expect(cat.testsCount, 14);
    expect(testItem.price, 499);
    expect(testItem.fastingRequired, isTrue);
  });
}
