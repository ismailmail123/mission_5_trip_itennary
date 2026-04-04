import 'package:hive/hive.dart';
import 'package:trips/data/models/trip_model.dart';

class HiveTripService {
  static const String _boxName = 'trips';
  static Box<TripModel>? _box;

  static Future<void> init() async {
    try {
      // Pastikan adapter sudah terdaftar
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TripModelAdapter());
      }

      // Cek apakah box sudah ada dan buka
      if (Hive.isBoxOpen(_boxName)) {
        _box = Hive.box<TripModel>(_boxName);
      } else {
        // Buka box baru
        _box = await Hive.openBox<TripModel>(_boxName);
      }

      print('✅ Hive trips box opened. Length: ${_box?.length}');

      // Cek apakah data ada, jika tidak ada, inisialisasi
      if (_box?.isEmpty ?? true) {
        await _initializeDefaultTrips();
      }
    } catch (e) {
      print('❌ Error opening Hive box: $e');

      // Jika error, hapus dan buat baru
      try {
        await Hive.deleteBoxFromDisk(_boxName);
        _box = await Hive.openBox<TripModel>(_boxName);
        await _initializeDefaultTrips();
        print('✅ Hive box recreated successfully');
      } catch (e2) {
        print('❌ Fatal error: $e2');
      }
    }
  }

  static Future<void> _initializeDefaultTrips() async {
    final now = DateTime.now();

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
        startDate: DateTime(now.year, now.month, now.day + 30),
        endDate: DateTime(now.year, now.month, now.day + 37),
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
        isBooked: false,
        startDate: DateTime(now.year, now.month, now.day + 15),
        endDate: DateTime(now.year, now.month, now.day + 20),
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
        startDate: DateTime(now.year, now.month, now.day + 45),
        endDate: DateTime(now.year, now.month, now.day + 49),
      ),
      TripModel(
        id: '4',
        title: 'Bangkok Street Food',
        location: 'Bangkok, Thailand',
        image: 'https://images.unsplash.com/photo-1559314809-0d155014e29e',
        description: 'Experience the best street food in Bangkok with guided tours',
        price: 450.0,
        rating: 4.6,
        category: 'Food',
        features: ['Food Tour', 'Culture', 'Night Market'],
        isBooked: false,
        startDate: DateTime(now.year, now.month, now.day - 5),
        endDate: DateTime(now.year, now.month, now.day + 2),
      ),
    ];

    for (final trip in defaultTrips) {
      await _box?.put(trip.id, trip);
    }

    print('✅ Initialized ${defaultTrips.length} default trips with dates');
  }

  static Future<void> resetAndInitialize() async {
    try {
      await _box?.clear();
      await _initializeDefaultTrips();
      print('✅ Trips reset and initialized');
    } catch (e) {
      print('❌ Error resetting trips: $e');
    }
  }

  static Future<List<TripModel>> getAllTrips() async {
    if (_box == null) await init();
    return _box?.values.toList() ?? [];
  }

  static Future<TripModel?> getTripById(String id) async {
    if (_box == null) await init();
    return _box?.get(id);
  }

  static Future<void> addTrip(TripModel trip) async {
    if (_box == null) await init();
    await _box?.put(trip.id, trip);
  }

  static Future<void> updateTrip(String id, TripModel updatedTrip) async {
    if (_box == null) await init();
    await _box?.put(id, updatedTrip);
  }

  static Future<void> deleteTrip(String id) async {
    if (_box == null) await init();
    await _box?.delete(id);
  }

  static Future<void> bookTrip(String id) async {
    if (_box == null) await init();
    final trip = _box?.get(id);
    if (trip != null) {
      final updatedTrip = trip.copyWith(isBooked: true);
      await _box?.put(id, updatedTrip);
    }
  }

  static Future<void> cancelBooking(String id) async {
    if (_box == null) await init();
    final trip = _box?.get(id);
    if (trip != null) {
      final updatedTrip = trip.copyWith(isBooked: false);
      await _box?.put(id, updatedTrip);
    }
  }
}