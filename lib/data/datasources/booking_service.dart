import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trips/data/models/booking_model.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Collection references
  CollectionReference get _bookingsCollection => _firestore.collection('bookings');

  // ==================== CREATE BOOKING ====================
  Future<BookingModel?> createBooking({
    required String userId,
    required TripModel trip,
  }) async {
    try {
      final bookingId = _uuid.v4();
      final now = DateTime.now();

      final newBooking = BookingModel(
        id: bookingId,
        userId: userId,
        tripId: trip.id,
        tripTitle: trip.title,
        tripLocation: trip.location,
        tripImage: trip.image,
        tripPrice: trip.price,
        tripRating: trip.rating,
        tripCategory: trip.category,
        tripFeatures: trip.features,
        tripStartDate: trip.startDate,
        tripEndDate: trip.endDate,
        bookedAt: now,
        status: 'active',
      );

      await _bookingsCollection.doc(bookingId).set(newBooking.toMap());
      print('Booking created successfully with dates: ${trip.startDate} - ${trip.endDate}');
      return newBooking;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  // ==================== CANCEL BOOKING ====================
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _bookingsCollection.doc(bookingId).update({
        'status': 'cancelled',
        'cancelledAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

  // ==================== GET USER BOOKINGS (ALL STATUS) ====================
  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _bookingsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('bookedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // ==================== GET USER BOOKING BY TRIP ID ====================
  Future<BookingModel?> getUserBookingByTripId(String userId, String tripId) async {
    try {
      final querySnapshot = await _bookingsCollection
          .where('userId', isEqualTo: userId)
          .where('tripId', isEqualTo: tripId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return BookingModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Error getting user booking: $e');
      return null;
    }
  }

  // ==================== CHECK IF TRIP IS BOOKED BY USER ====================
  Future<bool> isTripBookedByUser(String userId, String tripId) async {
    try {
      final querySnapshot = await _bookingsCollection
          .where('userId', isEqualTo: userId)
          .where('tripId', isEqualTo: tripId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking trip booking: $e');
      return false;
    }
  }

  // ==================== DELETE BOOKING (admin only) ====================
  Future<bool> deleteBooking(String bookingId) async {
    try {
      await _bookingsCollection.doc(bookingId).delete();
      return true;
    } catch (e) {
      print('Error deleting booking: $e');
      return false;
    }
  }
}