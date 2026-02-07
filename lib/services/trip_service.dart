import '../models/trip_model.dart';

class TripService {
  // Data dummy trips - GOLDEN PAVILION
  List<TripModel> _trips = [
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

  // GET ALL trips
  List<TripModel> getAllTrips() {
    return List.from(_trips);
  }

  // GET trip by ID
  TripModel? getTripById(String id) {
    try {
      return _trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  // GET booked trips
  List<TripModel> getBookedTrips() {
    return _trips.where((trip) => trip.isBooked).toList();
  }

  // CREATE new trip
  void addTrip(TripModel newTrip) {
    _trips.add(newTrip);
  }

  // UPDATE trip
  void updateTrip(String id, TripModel updatedTrip) {
    final index = _trips.indexWhere((trip) => trip.id == id);
    if (index != -1) {
      _trips[index] = updatedTrip;
    }
  }

  // DELETE trip
  void deleteTrip(String id) {
    _trips.removeWhere((trip) => trip.id == id);
  }

  // BOOK trip
  void bookTrip(String id) {
    final index = _trips.indexWhere((trip) => trip.id == id);
    if (index != -1) {
      _trips[index] = _trips[index].copyWith(isBooked: true);
    }
  }

  // CANCEL booking
  void cancelBooking(String id) {
    final index = _trips.indexWhere((trip) => trip.id == id);
    if (index != -1) {
      _trips[index] = _trips[index].copyWith(isBooked: false);
    }
  }
}