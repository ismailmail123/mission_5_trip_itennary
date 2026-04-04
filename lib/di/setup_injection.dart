import 'package:trips/data/datasources/firestore_trip_service.dart';
import 'package:trips/data/repositories/trip_repository_impl.dart';
import 'package:trips/domain/repositories/trip_repository.dart';

/// SetupInjection menyediakan dependency secara manual.
/// Untuk Riverpod providers, lihat presentation/controller/.
class SetupInjection {
  static SetupInjection? _instance;
  static SetupInjection get instance => _instance ??= SetupInjection._();
  SetupInjection._();

  // Datasources
  late final FirestoreTripService firestoreTripService = FirestoreTripService();

  // Repositories
  late final TripRepository tripRepository =
      TripRepositoryImpl(firestoreTripService);
}
