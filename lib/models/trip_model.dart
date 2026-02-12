import 'package:hive/hive.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1) // typeId 1 untuk trip, 0 untuk user
class TripModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final double rating;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final List<String> features;

  @HiveField(9)
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