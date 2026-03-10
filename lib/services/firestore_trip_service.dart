import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:trips/models/trip_model.dart';

class FirestoreTripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Collection references
  CollectionReference get _tripsCollection => _firestore.collection('trips');

  // ==================== PICK IMAGE ====================
  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // ==================== GET ALL TRIPS ====================
  Future<List<TripModel>> getAllTrips() async {
    try {
      QuerySnapshot snapshot = await _tripsCollection.get();
      return snapshot.docs.map((doc) {
        return TripModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting trips: $e');
      return [];
    }
  }

  // ==================== GET TRIP BY ID ====================
  Future<TripModel?> getTripById(String id) async {
    try {
      DocumentSnapshot doc = await _tripsCollection.doc(id).get();
      if (doc.exists) {
        return TripModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting trip: $e');
      return null;
    }
  }

  // ==================== ADD TRIP ====================
  Future<bool> addTrip(TripModel trip) async {
    try {
      await _tripsCollection.doc(trip.id).set(trip.toMap());
      return true;
    } catch (e) {
      print('Error adding trip: $e');
      return false;
    }
  }

  // ==================== UPDATE TRIP ====================
  Future<bool> updateTrip(String id, TripModel updatedTrip) async {
    try {
      await _tripsCollection.doc(id).update(updatedTrip.toMap());
      return true;
    } catch (e) {
      print('Error updating trip: $e');
      return false;
    }
  }

  // ==================== DELETE TRIP ====================
  Future<bool> deleteTrip(String id) async {
    try {
      await _tripsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting trip: $e');
      return false;
    }
  }

  // ==================== BOOK TRIP ====================
  Future<bool> bookTrip(String id) async {
    try {
      await _tripsCollection.doc(id).update({'isBooked': true});
      return true;
    } catch (e) {
      print('Error booking trip: $e');
      return false;
    }
  }

  // ==================== CANCEL BOOKING ====================
  Future<bool> cancelBooking(String id) async {
    try {
      await _tripsCollection.doc(id).update({'isBooked': false});
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

  // ==================== GET BOOKED TRIPS ====================
  Future<List<TripModel>> getBookedTrips() async {
    try {
      QuerySnapshot snapshot = await _tripsCollection
          .where('isBooked', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) {
        return TripModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting booked trips: $e');
      return [];
    }
  }

  // ==================== GET TRIPS BY STATUS ====================
  Future<List<TripModel>> getTripsByStatus(String status) async {
    try {
      final allTrips = await getAllTrips();
      final now = DateTime.now();

      switch (status) {
        case 'upcoming':
          return allTrips.where((trip) => trip.startDate.isAfter(now)).toList();
        case 'ongoing':
          return allTrips.where((trip) =>
          trip.startDate.isBefore(now) && trip.endDate.isAfter(now)).toList();
        case 'completed':
          return allTrips.where((trip) => trip.endDate.isBefore(now)).toList();
        default:
          return allTrips;
      }
    } catch (e) {
      print('Error getting trips by status: $e');
      return [];
    }
  }

  // ==================== GET TRIPS BY MONTH AND YEAR ====================
  Future<List<TripModel>> getTripsByMonthYear(int month, int year) async {
    try {
      final allTrips = await getAllTrips();
      return allTrips.where((trip) =>
      trip.startDate.month == month && trip.startDate.year == year).toList();
    } catch (e) {
      print('Error getting trips by month/year: $e');
      return [];
    }
  }

  // ==================== INITIALIZE DEFAULT TRIPS ====================
  Future<void> initializeDefaultTrips() async {
    try {
      // Cek apakah sudah ada data
      final existingTrips = await getAllTrips();
      if (existingTrips.isNotEmpty) return;

      final now = DateTime.now();

      // Data dummy trips dengan startDate dan endDate
      final defaultTrips = [
        TripModel(
          id: _uuid.v4(),
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
          id: _uuid.v4(),
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
          id: _uuid.v4(),
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
          id: _uuid.v4(),
          title: 'Bangkok Street Food',
          location: 'Bangkok, Thailand',
          image: 'https://images.unsplash.com/photo-1559314809-0d155014e29e',
          description: 'Experience the best street food in Bangkok with guided tours',
          price: 450.0,
          rating: 4.6,
          category: 'Food',
          features: ['Food Tour', 'Culture', 'Night Market'],
          isBooked: false,
          startDate: DateTime(now.year, now.month, now.day - 5), // 5 hari yang lalu
          endDate: DateTime(now.year, now.month, now.day + 2),   // 2 hari lagi
        ),
        // Contoh trip yang sudah selesai (completed)
        TripModel(
          id: _uuid.v4(),
          title: 'Paris Art Exhibition',
          location: 'Paris, France',
          image: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
          description: 'Explore the finest art exhibitions in the city of love',
          price: 1200.0,
          rating: 4.9,
          category: 'Art',
          features: ['Museum', 'Art Gallery', 'Culture'],
          isBooked: false,
          startDate: DateTime(now.year, now.month, now.day - 20),
          endDate: DateTime(now.year, now.month, now.day - 15),
        ),
        // Contoh trip upcoming dengan kategori lain
        TripModel(
          id: _uuid.v4(),
          title: 'Swiss Alps Hiking',
          location: 'Switzerland',
          image: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2',
          description: 'Experience breathtaking views and challenging trails in the Swiss Alps',
          price: 1500.0,
          rating: 4.9,
          category: 'Adventure',
          features: ['Hiking', 'Mountain', 'Nature'],
          isBooked: false,
          startDate: DateTime(now.year, now.month + 2, 15), // 2 bulan dari sekarang
          endDate: DateTime(now.year, now.month + 2, 22),
        ),
      ];

      for (final trip in defaultTrips) {
        await _tripsCollection.doc(trip.id).set(trip.toMap());
      }

      print('Default trips initialized successfully with dates');
    } catch (e) {
      print('Error initializing default trips: $e');
    }
  }

  // ==================== SEARCH TRIPS WITH FILTERS ====================
  Future<List<TripModel>> searchTrips({
    String? query,
    String? category,
    int? month,
    int? year,
    String? status,
  }) async {
    try {
      var allTrips = await getAllTrips();

      // Filter by search query
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        allTrips = allTrips.where((trip) =>
        trip.title.toLowerCase().contains(lowerQuery) ||
            trip.location.toLowerCase().contains(lowerQuery) ||
            trip.category.toLowerCase().contains(lowerQuery)
        ).toList();
      }

      // Filter by category
      if (category != null && category.isNotEmpty) {
        allTrips = allTrips.where((trip) =>
        trip.category.toLowerCase() == category.toLowerCase()
        ).toList();
      }

      // Filter by month and year
      if (month != null && year != null) {
        allTrips = allTrips.where((trip) =>
        trip.startDate.month == month && trip.startDate.year == year
        ).toList();
      }

      // Filter by status
      if (status != null && status != 'all') {
        final now = DateTime.now();
        switch (status) {
          case 'upcoming':
            allTrips = allTrips.where((trip) => trip.startDate.isAfter(now)).toList();
            break;
          case 'ongoing':
            allTrips = allTrips.where((trip) =>
            trip.startDate.isBefore(now) && trip.endDate.isAfter(now)
            ).toList();
            break;
          case 'completed':
            allTrips = allTrips.where((trip) => trip.endDate.isBefore(now)).toList();
            break;
        }
      }

      return allTrips;
    } catch (e) {
      print('Error searching trips: $e');
      return [];
    }
  }
}