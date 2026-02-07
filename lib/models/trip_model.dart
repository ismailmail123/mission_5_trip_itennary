class TripModel {
  final String id;
  final String title;
  final String location;
  final String image;
  final String description;
  final double price;
  final double rating;
  final String category;
  final List<String> features;
  final bool isBooked;

  TripModel({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.category,
    this.features = const [],
    this.isBooked = false,
  });

  // Copy with method untuk update
  TripModel copyWith({
    String? id,
    String? title,
    String? location,
    String? image,
    String? description,
    double? price,
    double? rating,
    String? category,
    List<String>? features,
    bool? isBooked,
  }) {
    return TripModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      features: features ?? this.features,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'image': image,
      'description': description,
      'price': price,
      'rating': rating,
      'category': category,
      'features': features,
      'isBooked': isBooked,
    };
  }

  // Create from Map
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      rating: map['rating']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      features: List<String>.from(map['features'] ?? []),
      isBooked: map['isBooked'] ?? false,
    );
  }
}