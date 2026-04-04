import 'package:trips/data/models/trip_model.dart';

abstract class TripRepository {
  Future<List<TripModel>> getAllTrips();
  Future<TripModel?> getTripById(String id);
  Future<List<TripModel>> getBookedTrips();
  Future<bool> addTrip(TripModel trip);
  Future<bool> updateTrip(String id, TripModel trip);
  Future<bool> deleteTrip(String id);
  Future<bool> bookTrip(String id);
  Future<bool> cancelBooking(String id);
}
