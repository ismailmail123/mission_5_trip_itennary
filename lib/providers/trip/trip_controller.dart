import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/trip/trip_state.dart';
import 'package:trips/services/trip_service.dart';

class TripController extends Notifier<TripState> {
  @override
  TripState build() {
    _loadTrips();
    return TripState.initial();
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await HiveTripService.getAllTrips();
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshTrips() async {
    state = state.copyWith(isLoading: true);
    try {
      final trips = await HiveTripService.getAllTrips();
      state = state.copyWith(trips: trips, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addTrip(TripModel newTrip) async {
    try {
      await HiveTripService.addTrip(newTrip);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateTrip(String id, TripModel updatedTrip) async {
    try {
      await HiveTripService.updateTrip(id, updatedTrip);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTrip(String id) async {
    try {
      await HiveTripService.deleteTrip(id);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> bookTrip(String id) async {
    try {
      await HiveTripService.bookTrip(id);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      await HiveTripService.cancelBooking(id);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  TripModel? getTripById(String id) {
    try {
      return state.trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  List<TripModel> getBookedTrips() {
    return state.trips.where((trip) => trip.isBooked).toList();
  }
}

final tripProvider = NotifierProvider<TripController, TripState>(
      () => TripController(),
);