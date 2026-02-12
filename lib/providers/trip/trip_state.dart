import 'package:trips/models/trip_model.dart';

class TripState {
  final List<TripModel> trips;
  final bool isLoading;
  final String? error;

  const TripState({
    required this.trips,
    this.isLoading = false,
    this.error,
  });

  TripState copyWith({
    List<TripModel>? trips,
    bool? isLoading,
    String? error,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  static TripState initial() => TripState(trips: []);
}