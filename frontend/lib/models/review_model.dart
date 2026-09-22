class Review {
  final String id;
  final String author;
  final int rating;
  final String comment;
  final bool verified;
  final String? location;
  final String? avatarUrl;
  final String? createdAt;

  Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.comment,
    this.verified = true,
    this.location,
    this.avatarUrl,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      verified: json['verified'] ?? true,
      location: json['location'],
      avatarUrl: json['avatarUrl'],
      createdAt: json['createdAt'],
    );
  }
}

class LabPartner {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;

  LabPartner({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.rating,
  });

  factory LabPartner.fromJson(Map<String, dynamic> json) {
    return LabPartner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }
}
