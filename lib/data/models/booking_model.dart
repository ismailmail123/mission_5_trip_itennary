import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String tripId;
  final String tripTitle;
  final String tripLocation;
  final String tripImage;
  final double tripPrice;
  final double tripRating;
  final String tripCategory;
  final List<String> tripFeatures;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final DateTime bookedAt;
  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.tripTitle,
    required this.tripLocation,
    required this.tripImage,
    required this.tripPrice,
    required this.tripRating,
    required this.tripCategory,
    required this.tripFeatures,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.bookedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'tripTitle': tripTitle,
      'tripLocation': tripLocation,
      'tripImage': tripImage,
      'tripPrice': tripPrice,
      'tripRating': tripRating,
      'tripCategory': tripCategory,
      'tripFeatures': tripFeatures,
      'tripStartDate': Timestamp.fromDate(tripStartDate),
      'tripEndDate': Timestamp.fromDate(tripEndDate),
      'bookedAt': Timestamp.fromDate(bookedAt),
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      id: documentId,
      userId: map['userId'] ?? '',
      tripId: map['tripId'] ?? '',
      tripTitle: map['tripTitle'] ?? '',
      tripLocation: map['tripLocation'] ?? '',
      tripImage: map['tripImage'] ?? '',
      tripPrice: map['tripPrice']?.toDouble() ?? 0.0,
      tripRating: map['tripRating']?.toDouble() ?? 0.0,
      tripCategory: map['tripCategory'] ?? '',
      tripFeatures: List<String>.from(map['tripFeatures'] ?? []),
      tripStartDate: _parseDate(map['tripStartDate']),
      tripEndDate: _parseDate(map['tripEndDate']),
      bookedAt: (map['bookedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'active',
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    if (value is DateTime) return value;
    return DateTime.now();
  }

  // ==================== COPY WITH YANG BENAR ====================
  BookingModel copyWith({
    String? id,
    String? userId,
    String? tripId,
    String? tripTitle,
    String? tripLocation,
    String? tripImage,
    double? tripPrice,
    double? tripRating,
    String? tripCategory,
    List<String>? tripFeatures,
    DateTime? tripStartDate,
    DateTime? tripEndDate,
    DateTime? bookedAt,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      tripTitle: tripTitle ?? this.tripTitle,
      tripLocation: tripLocation ?? this.tripLocation,
      tripImage: tripImage ?? this.tripImage,
      tripPrice: tripPrice ?? this.tripPrice,
      tripRating: tripRating ?? this.tripRating,
      tripCategory: tripCategory ?? this.tripCategory,
      tripFeatures: tripFeatures ?? this.tripFeatures,
      tripStartDate: tripStartDate ?? this.tripStartDate,
      tripEndDate: tripEndDate ?? this.tripEndDate,
      bookedAt: bookedAt ?? this.bookedAt,
      status: status ?? this.status,
    );
  }
}