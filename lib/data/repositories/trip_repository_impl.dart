import 'package:trips/data/datasources/firestore_trip_service.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:trips/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final FirestoreTripService _dataSource;

  TripRepositoryImpl(this._dataSource);

  @override
  Future<List<TripModel>> getAllTrips() => _dataSource.getAllTrips();

  @override
  Future<TripModel?> getTripById(String id) => _dataSource.getTripById(id);

  @override
  Future<List<TripModel>> getBookedTrips() => _dataSource.getBookedTrips();

  @override
  Future<bool> addTrip(TripModel trip) => _dataSource.addTrip(trip);

  @override
  Future<bool> updateTrip(String id, TripModel trip) =>
      _dataSource.updateTrip(id, trip);

  @override
  Future<bool> deleteTrip(String id) => _dataSource.deleteTrip(id);

  @override
  Future<bool> bookTrip(String id) => _dataSource.bookTrip(id);

  @override
  Future<bool> cancelBooking(String id) => _dataSource.cancelBooking(id);
}
