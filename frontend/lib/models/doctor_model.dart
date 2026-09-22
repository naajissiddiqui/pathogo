class Doctor {
  final String id;
  final String slug;
  final String name;
  final String specialty;
  final String specialtySlug;
  final int experienceYrs;
  final String qualification;
  final String hospital;
  final double consultationFee;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> availableDays;
  final List<String> timeSlots;
  final String about;

  Doctor({
    required this.id,
    required this.slug,
    required this.name,
    required this.specialty,
    required this.specialtySlug,
    required this.experienceYrs,
    required this.qualification,
    required this.hospital,
    required this.consultationFee,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.availableDays,
    required this.timeSlots,
    required this.about,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      specialtySlug: json['specialtySlug'] ?? '',
      experienceYrs: json['experienceYrs'] ?? 0,
      qualification: json['qualification'] ?? '',
      hospital: json['hospital'] ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 500.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      availableDays: json['availableDays'] != null
          ? List<String>.from(json['availableDays'])
          : [],
      timeSlots: json['timeSlots'] != null
          ? List<String>.from(json['timeSlots'])
          : [],
      about: json['about'] ?? '',
    );
  }
}
