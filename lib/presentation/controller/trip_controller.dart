import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:trips/data/models/booking_model.dart';
import 'package:trips/presentation/controller/trip_state.dart';
import 'package:trips/data/datasources/firestore_trip_service.dart';
import 'package:trips/data/datasources/booking_service.dart';
import 'package:trips/presentation/controller/auth_controller.dart';

class TripController extends Notifier<TripState> {
  late FirestoreTripService _tripService;
  late BookingService _bookingService;

  @override
  TripState build() {
    _tripService = FirestoreTripService();
    _bookingService = BookingService();
    _loadTrips();
    return TripState.initial();
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await _tripService.getAllTrips();
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshTrips() async {
    state = state.copyWith(isLoading: true);
    try {
      final trips = await _tripService.getAllTrips();
      state = state.copyWith(trips: trips, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  List<TripModel> searchTrips(String query) {
    if (query.isEmpty) return state.trips;

    final lowerQuery = query.toLowerCase();
    return state.trips.where((trip) {
      return trip.title.toLowerCase().contains(lowerQuery) ||
          trip.location.toLowerCase().contains(lowerQuery) ||
          trip.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<TripModel> sortTrips(List<TripModel> trips, String sortBy, bool ascending) {
    final sorted = List<TripModel>.from(trips);

    switch (sortBy) {
      case 'price':
        sorted.sort((a, b) => ascending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
        break;
      case 'rating':
        sorted.sort((a, b) => ascending
            ? a.rating.compareTo(b.rating)
            : b.rating.compareTo(a.rating));
        break;
      case 'title':
        sorted.sort((a, b) => ascending
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
    }

    return sorted;
  }

  List<TripModel> filterByStatus(List<TripModel> trips, String status) {
    if (status == 'all') return trips;

    // Asumsi: upcoming = rating > 4.5, ongoing = rating <= 4.5
    if (status == 'upcoming') {
      return trips.where((trip) => trip.rating > 4.5).toList();
    } else if (status == 'ongoing') {
      return trips.where((trip) => trip.rating <= 4.5).toList();
    }

    return trips;
  }

  // ==================== BOOK TRIP ====================
  Future<bool> bookTrip(String tripId) async {
    try {
      // Dapatkan userId dari AuthController
      final authController = ref.read(authProvider.notifier);
      final userId = authController.getCurrentUserId();

      if (userId == null) {
        state = state.copyWith(error: 'User not logged in');
        return false;
      }

      // Dapatkan data trip
      final trip = getTripById(tripId);
      if (trip == null) {
        state = state.copyWith(error: 'Trip not found');
        return false;
      }

      // Cek apakah sudah pernah booking trip ini
      final existingBooking = await _bookingService.getUserBookingByTripId(userId, tripId);
      if (existingBooking != null) {
        state = state.copyWith(error: 'You have already booked this trip');
        return false;
      }

      // Buat booking di Firestore
      final booking = await _bookingService.createBooking(
        userId: userId,
        trip: trip,
      );

      if (booking != null) {
        // Update status isBooked di trip
        await _tripService.bookTrip(tripId);

        // Refresh trips
        await refreshTrips();

        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ==================== CANCEL BOOKING ====================
  Future<bool> cancelBooking(String tripId) async {
    try {
      // Dapatkan userId dari AuthController
      final authController = ref.read(authProvider.notifier);
      final userId = authController.getCurrentUserId();

      if (userId == null) {
        state = state.copyWith(error: 'User not logged in');
        return false;
      }

      // Dapatkan booking yang aktif untuk trip ini
      final booking = await _bookingService.getUserBookingByTripId(userId, tripId);

      if (booking == null) {
        state = state.copyWith(error: 'Booking not found');
        return false;
      }

      // Cancel booking
      final success = await _bookingService.cancelBooking(booking.id);

      if (success) {
        // Update status isBooked di trip
        await _tripService.cancelBooking(tripId);

        // Refresh trips
        await refreshTrips();

        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ==================== GET USER BOOKINGS (ALL STATUS) ====================
  Stream<List<BookingModel>> getUserBookings() {
    final authController = ref.read(authProvider.notifier);
    final userId = authController.getCurrentUserId();

    if (userId == null) {
      return Stream.value([]);
    }

    // Hapus filter status, ambil semua booking untuk user ini
    return _bookingService.getUserBookings(userId);
  }

  // ==================== CHECK IF TRIP IS BOOKED BY CURRENT USER ====================
  Future<bool> isTripBookedByCurrentUser(String tripId) async {
    final authController = ref.read(authProvider.notifier);
    final userId = authController.getCurrentUserId();

    if (userId == null) return false;

    return await _bookingService.isTripBookedByUser(userId, tripId);
  }

  // ==================== ADD TRIP (TANPA IMAGE FILE) ====================
  Future<bool> addTrip(TripModel newTrip) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _tripService.addTrip(newTrip);
      if (success) {
        await refreshTrips();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  // ==================== UPDATE TRIP (TANPA IMAGE FILE) ====================
  Future<bool> updateTrip(String id, TripModel updatedTrip) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _tripService.updateTrip(id, updatedTrip);
      if (success) {
        await refreshTrips();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  // ==================== PICK IMAGE (UNTUK PREVIEW) ====================
  Future<XFile?> pickImage() async {
    return await _tripService.pickImage();
  }

  // ==================== DELETE TRIP ====================
  Future<void> deleteTrip(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _tripService.deleteTrip(id);
      await refreshTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // ==================== GET TRIP BY ID ====================
  TripModel? getTripById(String id) {
    try {
      return state.trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== GET BOOKED TRIPS ====================
  List<TripModel> getBookedTrips() {
    return state.trips.where((trip) => trip.isBooked).toList();
  }
}


final tripProvider = NotifierProvider<TripController, TripState>(
      () => TripController(),
);