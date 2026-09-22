class TestCategory {
  final String id;
  final String slug;
  final String name;
  final String iconName;
  final int testsCount;

  TestCategory({
    required this.id,
    required this.slug,
    required this.name,
    required this.iconName,
    required this.testsCount,
  });

  factory TestCategory.fromJson(Map<String, dynamic> json) {
    return TestCategory(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      iconName: json['iconName'] ?? 'activity',
      testsCount: json['testsCount'] ?? (json['_count'] != null ? json['_count']['tests'] : 0),
    );
  }
}

class LabTest {
  final String id;
  final String slug;
  final String name;
  final String? code;
  final String categorySlug;
  final double price;
  final double? originalPrice;
  final String description;
  final bool fastingRequired;
  final int reportTimeHours;
  final TestCategory? category;

  LabTest({
    required this.id,
    required this.slug,
    required this.name,
    this.code,
    required this.categorySlug,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.fastingRequired,
    required this.reportTimeHours,
    this.category,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
      categorySlug: json['categorySlug'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      description: json['description'] ?? '',
      fastingRequired: json['fastingRequired'] ?? false,
      reportTimeHours: json['reportTimeHours'] ?? 24,
      category: json['category'] != null
          ? TestCategory.fromJson(json['category'])
          : null,
    );
  }
}
