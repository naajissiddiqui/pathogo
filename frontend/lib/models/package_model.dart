class PackageCategory {
  final String id;
  final String slug;
  final String name;
  final String? description;
  final int? packagesCount;

  PackageCategory({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.packagesCount,
  });

  factory PackageCategory.fromJson(Map<String, dynamic> json) {
    return PackageCategory(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      packagesCount: json['_count'] != null ? json['_count']['packages'] : null,
    );
  }
}

class HealthPackage {
  final String id;
  final String slug;
  final String name;
  final String description;
  final String categorySlug;
  final double originalPrice;
  final double discountPrice;
  final int discountPercent;
  final int testCount;
  final bool isPopular;
  final int reportTimeHours;
  final bool fastingRequired;
  final List<String> includedSummary;
  final PackageCategory? category;

  HealthPackage({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.categorySlug,
    required this.originalPrice,
    required this.discountPrice,
    required this.discountPercent,
    required this.testCount,
    required this.isPopular,
    required this.reportTimeHours,
    required this.fastingRequired,
    required this.includedSummary,
    this.category,
  });

  factory HealthPackage.fromJson(Map<String, dynamic> json) {
    return HealthPackage(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      categorySlug: json['categorySlug'] ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: json['discountPercent'] ?? 0,
      testCount: json['testCount'] ?? 0,
      isPopular: json['isPopular'] ?? false,
      reportTimeHours: json['reportTimeHours'] ?? 24,
      fastingRequired: json['fastingRequired'] ?? false,
      includedSummary: json['includedSummary'] != null
          ? List<String>.from(json['includedSummary'])
          : [],
      category: json['category'] != null
          ? PackageCategory.fromJson(json['category'])
          : null,
    );
  }
}
