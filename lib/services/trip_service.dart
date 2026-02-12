import 'package:hive/hive.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/helpers/trip_constans.dart';

class HiveTripService {
  static const String tripBoxName = 'trips';

  // ==================== INISIALISASI ====================
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TripModelAdapter());
    }
    await Hive.openBox<TripModel>(tripBoxName);
  }

  // ==================== RESET DAN INITIAL DATA ====================
  static Future<void> resetAndInitialize() async {
    final box = Hive.box<TripModel>(tripBoxName);
    await box.clear(); // Hapus semua data trip lama

    // Data dummy dari TripService
    final defaultTrips = [
      TripModel(
        id: '1',
        title: 'Golden Pavillion',
        location: 'Kyoto, Japan',
        image: 'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8',
        description: 'Embark on a tranquil journey to Japan\'s iconic Kinkaku-ji Temple, also known as the Golden Pavilion. Set against the serene backdrop of Kyoto\'s lush gardens and calm ponds, this Zen Buddhist temple radiates golden beauty and deep historical and spiritual significance.',
        price: 500.0,
        rating: 4.8,
        category: 'Cultural',
        features: ['Historic Site', 'Garden', 'Temple'],
        isBooked: false,
      ),
      TripModel(
        id: '2',
        title: 'Bali Adventure',
        location: 'Bali, Indonesia',
        image: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
        description: 'Nature, Culture and Beach experience in beautiful Bali',
        price: 899.0,
        rating: 4.9,
        category: 'Adventure',
        features: ['Beach', 'Culture', 'Nature'],
        isBooked: true,
      ),
      TripModel(
        id: '3',
        title: 'Busan Exploration',
        location: 'Busan, South Korea',
        image: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf',
        description: 'Explore the vibrant city of Busan with its beautiful beaches and delicious food',
        price: 750.0,
        rating: 4.7,
        category: 'City',
        features: ['City Tour', 'Food', 'Shopping'],
        isBooked: false,
      ),
    ];

    for (final trip in defaultTrips) {
      await box.put(trip.id, trip);
    }
  }

  // ==================== CRUD OPERATIONS ====================
  static Future<List<TripModel>> getAllTrips() async {
    final box = Hive.box<TripModel>(tripBoxName);
    return box.values.toList();
  }

  static Future<TripModel?> getTripById(String id) async {
    final box = Hive.box<TripModel>(tripBoxName);
    return box.get(id);
  }

  static Future<void> addTrip(TripModel trip) async {
    final box = Hive.box<TripModel>(tripBoxName);
    await box.put(trip.id, trip);
  }

  static Future<void> updateTrip(String id, TripModel updatedTrip) async {
    final box = Hive.box<TripModel>(tripBoxName);
    if (box.containsKey(id)) {
      await box.put(id, updatedTrip);
    }
  }

  static Future<void> deleteTrip(String id) async {
    final box = Hive.box<TripModel>(tripBoxName);
    await box.delete(id);
  }

  static Future<void> bookTrip(String id) async {
    final box = Hive.box<TripModel>(tripBoxName);
    final trip = box.get(id);
    if (trip != null) {
      final updated = trip.copyWith(isBooked: true);
      await box.put(id, updated);
    }
  }

  static Future<void> cancelBooking(String id) async {
    final box = Hive.box<TripModel>(tripBoxName);
    final trip = box.get(id);
    if (trip != null) {
      final updated = trip.copyWith(isBooked: false);
      await box.put(id, updated);
    }
  }

  static Future<List<TripModel>> getBookedTrips() async {
    final box = Hive.box<TripModel>(tripBoxName);
    return box.values.where((trip) => trip.isBooked).toList();
  }
}