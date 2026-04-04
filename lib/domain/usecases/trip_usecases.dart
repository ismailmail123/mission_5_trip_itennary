import 'package:trips/data/models/trip_model.dart';
import 'package:trips/domain/repositories/trip_repository.dart';

class GetAllTripsUseCase {
  final TripRepository repository;
  GetAllTripsUseCase(this.repository);
  Future<List<TripModel>> execute() => repository.getAllTrips();
}

class AddTripUseCase {
  final TripRepository repository;
  AddTripUseCase(this.repository);
  Future<bool> execute(TripModel trip) => repository.addTrip(trip);
}

class UpdateTripUseCase {
  final TripRepository repository;
  UpdateTripUseCase(this.repository);
  Future<bool> execute(String id, TripModel trip) => repository.updateTrip(id, trip);
}

class DeleteTripUseCase {
  final TripRepository repository;
  DeleteTripUseCase(this.repository);
  Future<bool> execute(String id) => repository.deleteTrip(id);
}

class BookTripUseCase {
  final TripRepository repository;
  BookTripUseCase(this.repository);
  Future<bool> execute(String id) => repository.bookTrip(id);
}

class CancelBookingUseCase {
  final TripRepository repository;
  CancelBookingUseCase(this.repository);
  Future<bool> execute(String id) => repository.cancelBooking(id);
}
