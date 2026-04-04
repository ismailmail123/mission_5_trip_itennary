// integration_test/search_controller_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:trips/presentation/controller/search_state.dart';

// ============ SEARCH CONTROLLER ============
class TestSearchController extends Notifier<SearchState> {
  List<TripModel> _trips = [];

  @override
  SearchState build() {
    // Initial state harus kosong
    return SearchState.initial();
  }

  void setTrips(List<TripModel> trips) {
    _trips = trips;
    _performSearch();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _performSearch();
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
    _performSearch();
  }

  void toggleSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
    _performSearch();
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
    _performSearch();
  }

  void setFilterMonth(String month) {
    state = state.copyWith(filterMonth: month);
    _performSearch();
  }

  void setFilterYear(String year) {
    state = state.copyWith(filterYear: year);
    _performSearch();
  }

  void setFilterCategory(String category) {
    state = state.copyWith(filterCategory: category);
    _performSearch();
  }

  void filterByMonthYearCategory(String month, String year, String category) {
    state = state.copyWith(
      filterMonth: month,
      filterYear: year,
      filterCategory: category,
      searchQuery: category,
    );
    _performSearch();
  }

  void resetFilters() {
    // Reset ke initial state dengan searchResults kosong
    state = SearchState.initial();
  }

  void _performSearch() {
    var results = List<TripModel>.from(_trips);

    // Filter berdasarkan isBooked = false (hanya trip yang tersedia)
    results = results.where((trip) => !trip.isBooked).toList();

    // Filter berdasarkan search query (title, location, category)
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      results = results.where((trip) {
        return trip.title.toLowerCase().contains(query) ||
            trip.location.toLowerCase().contains(query) ||
            trip.category.toLowerCase().contains(query);
      }).toList();
    }

    // Filter berdasarkan kategori
    if (state.filterCategory != null && state.filterCategory!.isNotEmpty) {
      results = results.where((trip) =>
      trip.category.toLowerCase() == state.filterCategory!.toLowerCase() ||
          trip.title.toLowerCase().contains(state.filterCategory!.toLowerCase())
      ).toList();
    }

    // Filter berdasarkan status
    final now = DateTime.now();
    if (state.filterStatus == 'upcoming') {
      results = results.where((trip) => trip.startDate.isAfter(now)).toList();
    } else if (state.filterStatus == 'ongoing') {
      results = results.where((trip) =>
      trip.startDate.isBefore(now) && trip.endDate.isAfter(now)).toList();
    } else if (state.filterStatus == 'completed') {
      results = results.where((trip) => trip.endDate.isBefore(now)).toList();
    }

    // Filter berdasarkan bulan dan tahun
    if (state.filterMonth != null && state.filterYear != null) {
      int? monthNumber = _monthNameToNumber(state.filterMonth!);
      int? yearNumber = int.tryParse(state.filterYear!);
      if (monthNumber != null && yearNumber != null) {
        results = results.where((trip) {
          return trip.startDate.month == monthNumber &&
              trip.startDate.year == yearNumber;
        }).toList();
      }
    }

    // SORTING
    switch (state.sortBy) {
      case 'price':
        if (state.sortAscending) {
          results.sort((a, b) => a.price.compareTo(b.price));
        } else {
          results.sort((a, b) => b.price.compareTo(a.price));
        }
        break;
      case 'rating':
        if (state.sortAscending) {
          results.sort((a, b) => a.rating.compareTo(b.rating));
        } else {
          results.sort((a, b) => b.rating.compareTo(a.rating));
        }
        break;
      case 'title':
        if (state.sortAscending) {
          results.sort((a, b) => a.title.compareTo(b.title));
        } else {
          results.sort((a, b) => b.title.compareTo(a.title));
        }
        break;
      default:
      // Default: sort by rating descending
        results.sort((a, b) => b.rating.compareTo(a.rating));
    }

    state = state.copyWith(searchResults: results);
  }

  int? _monthNameToNumber(String monthName) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    return months[monthName];
  }
}

final testSearchProvider = NotifierProvider<TestSearchController, SearchState>(
      () => TestSearchController(),
);

void main() {
  late ProviderContainer container;
  late List<TripModel> mockTrips;

  setUp(() {
    container = ProviderContainer();

    // Setup mock trips data
    mockTrips = [
      TripModel(
        id: '1',
        title: 'Bali Beach Tour',
        location: 'Bali, Indonesia',
        image: 'assets/images/bali_beach.jpg',
        description: 'Beautiful beach tour in Bali with stunning views',
        category: 'Beach',
        price: 1500000,
        rating: 4.5,
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 35)),
        features: const ['Swimming', 'Snorkeling'],
        isBooked: false,
      ),
      TripModel(
        id: '2',
        title: 'Jakarta City Tour',
        location: 'Jakarta, Indonesia',
        image: 'assets/images/jakarta_city.jpg',
        description: 'Explore the capital city of Indonesia',
        category: 'City',
        price: 800000,
        rating: 4.0,
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 12)),
        features: const ['Monas Visit', 'Old Town Tour'],
        isBooked: false,
      ),
      TripModel(
        id: '3',
        title: 'Yogyakarta Heritage',
        location: 'Yogyakarta, Indonesia',
        image: 'assets/images/yogyakarta.jpg',
        description: 'Cultural heritage tour in Yogyakarta',
        category: 'Culture',
        price: 1200000,
        rating: 4.8,
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 5)),
        features: const ['Borobudur Temple', 'Prambanan Temple'],
        isBooked: false,
      ),
      TripModel(
        id: '4',
        title: 'Lombok Adventure',
        location: 'Lombok, Indonesia',
        image: 'assets/images/lombok.jpg',
        description: 'Adventure and nature tour in Lombok',
        category: 'Adventure',
        price: 2000000,
        rating: 4.7,
        startDate: DateTime.now().add(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 20)),
        features: const ['Hiking', 'Waterfall', 'Island Hopping'],
        isBooked: true,
      ),
      TripModel(
        id: '5',
        title: 'Bandung Culinary',
        location: 'Bandung, Indonesia',
        image: 'assets/images/bandung.jpg',
        description: 'Culinary tour in Bandung',
        category: 'Culinary',
        price: 600000,
        rating: 4.2,
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        features: const ['Food Tasting', 'Cooking Class'],
        isBooked: false,
      ),
    ];
  });

  tearDown(() {
    container.dispose();
  });

  group('SearchController Integration Tests', () {
    test('Initial state should be correct', () {
      final searchState = container.read(testSearchProvider);

      expect(searchState.searchQuery, '');
      expect(searchState.sortBy, 'rating');
      expect(searchState.sortAscending, false);
      expect(searchState.filterStatus, 'all');
      expect(searchState.filterMonth, null);
      expect(searchState.filterYear, null);
      expect(searchState.filterCategory, null);
      expect(searchState.searchResults, []);
      expect(searchState.isLoading, false);
      expect(searchState.error, null);
    });

    test('setSearchQuery should filter trips by title', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Bali');

      final state = container.read(testSearchProvider);
      expect(state.searchQuery, 'Bali');
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.title, 'Bali Beach Tour');
    });

    test('setSearchQuery should filter trips by location', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Jakarta');

      final state = container.read(testSearchProvider);
      expect(state.searchQuery, 'Jakarta');
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.location, 'Jakarta, Indonesia');
    });

    test('setSearchQuery should filter trips by category', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Beach');

      final state = container.read(testSearchProvider);
      expect(state.searchQuery, 'Beach');
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.category, 'Beach');
    });

    test('setSearchQuery with empty string should return all available trips', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Bali');
      searchController.setSearchQuery('');

      final state = container.read(testSearchProvider);
      expect(state.searchResults.length, 4);
    });

    test('setSortBy should sort results by price ascending', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');
      searchController.setSortBy('price');
      searchController.toggleSortOrder();

      final state = container.read(testSearchProvider);
      expect(state.sortBy, 'price');
      expect(state.sortAscending, true);
      expect(state.searchResults[0].price, 600000);
      expect(state.searchResults[1].price, 800000);
      expect(state.searchResults[2].price, 1200000);
      expect(state.searchResults[3].price, 1500000);
    });

    test('setSortBy should sort results by price descending', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');
      searchController.setSortBy('price');

      final state = container.read(testSearchProvider);
      expect(state.sortBy, 'price');
      expect(state.sortAscending, false);
      expect(state.searchResults[0].price, 1500000);
      expect(state.searchResults[1].price, 1200000);
      expect(state.searchResults[2].price, 800000);
      expect(state.searchResults[3].price, 600000);
    });

    test('toggleSortOrder should reverse sorting order', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');
      searchController.setSortBy('price');

      expect(container.read(testSearchProvider).sortAscending, false);
      expect(container.read(testSearchProvider).searchResults[0].price, 1500000);

      searchController.toggleSortOrder();

      final state = container.read(testSearchProvider);
      expect(state.sortAscending, true);
      expect(state.searchResults[0].price, 600000);
    });

    test('setFilterStatus should filter upcoming trips', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setFilterStatus('upcoming');

      final state = container.read(testSearchProvider);
      expect(state.filterStatus, 'upcoming');
      expect(state.searchResults.every((trip) => trip.startDate.isAfter(DateTime.now())), true);
    });

    test('setFilterStatus should filter completed trips', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setFilterStatus('completed');

      final state = container.read(testSearchProvider);
      expect(state.filterStatus, 'completed');
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.title, 'Yogyakarta Heritage');
    });

    test('Booked trips should be filtered out from results', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');

      final state = container.read(testSearchProvider);
      expect(state.searchResults.any((trip) => trip.id == '4'), false);
      expect(state.searchResults.length, 4);
    });

    test('Combined filters should work correctly', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setFilterCategory('Beach');
      searchController.setFilterStatus('upcoming');

      final state = container.read(testSearchProvider);

      expect(state.searchResults.every((trip) =>
      trip.category == 'Beach' && trip.startDate.isAfter(DateTime.now())
      ), true);
    });

    test('Search with case insensitivity should work', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('bali');

      final state = container.read(testSearchProvider);
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.title, 'Bali Beach Tour');
    });

    test('Sorting with rating (default) should work correctly', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');

      final state = container.read(testSearchProvider);
      expect(state.sortBy, 'rating');
      expect(state.sortAscending, false);
      expect(state.searchResults[0].rating, 4.8);
      expect(state.searchResults[1].rating, 4.5);
      expect(state.searchResults[2].rating, 4.2);
      expect(state.searchResults[3].rating, 4.0);
    });

    test('Sorting by title should work alphabetically ascending', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');
      searchController.setSortBy('title');
      searchController.toggleSortOrder();

      final state = container.read(testSearchProvider);
      expect(state.sortBy, 'title');
      expect(state.sortAscending, true);
      expect(state.searchResults[0].title, 'Bali Beach Tour');
      expect(state.searchResults[1].title, 'Bandung Culinary');
      expect(state.searchResults[2].title, 'Jakarta City Tour');
      expect(state.searchResults[3].title, 'Yogyakarta Heritage');
    });

    test('Sorting by title should work alphabetically descending', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('');
      searchController.setSortBy('title');

      final state = container.read(testSearchProvider);
      expect(state.sortBy, 'title');
      expect(state.sortAscending, false);
      expect(state.searchResults[0].title, 'Yogyakarta Heritage');
      expect(state.searchResults[1].title, 'Jakarta City Tour');
      expect(state.searchResults[2].title, 'Bandung Culinary');
      expect(state.searchResults[3].title, 'Bali Beach Tour');
    });

    test('resetFilters should clear all filters and return to initial state', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Bali');
      searchController.setSortBy('price');
      searchController.toggleSortOrder();
      searchController.setFilterStatus('upcoming');
      searchController.setFilterMonth('Jan');
      searchController.setFilterYear('2025');

      // Verify filters are applied
      var state = container.read(testSearchProvider);
      expect(state.searchQuery, 'Bali');
      expect(state.sortBy, 'price');
      expect(state.filterStatus, 'upcoming');

      // Reset filters
      searchController.resetFilters();

      // Verify all filters are cleared and results are empty
      state = container.read(testSearchProvider);
      expect(state.searchQuery, '');
      expect(state.sortBy, 'rating');
      expect(state.sortAscending, false);
      expect(state.filterStatus, 'all');
      expect(state.filterMonth, null);
      expect(state.filterYear, null);
      expect(state.filterCategory, null);
      expect(state.searchResults, []); // Now this should be empty
    });

    test('Multiple filter changes should update state correctly', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('Tour');
      searchController.setSortBy('price');
      searchController.toggleSortOrder();
      searchController.setFilterStatus('upcoming');

      final state = container.read(testSearchProvider);

      expect(state.searchQuery, 'Tour');
      expect(state.sortBy, 'price');
      expect(state.sortAscending, true);
      expect(state.filterStatus, 'upcoming');

      expect(state.searchResults.every((trip) =>
      trip.title.contains('Tour') && trip.startDate.isAfter(DateTime.now())
      ), true);
    });
  });

  group('Edge Cases and Error Handling', () {
    test('Search with non-existent query should return empty results', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setSearchQuery('NonExistentTrip123');

      final state = container.read(testSearchProvider);
      expect(state.searchResults, []);
    });

    test('Filter with invalid month should not break the app', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips(mockTrips);
      searchController.setFilterMonth('Invalid');

      final state = container.read(testSearchProvider);
      expect(state.filterMonth, 'Invalid');
      expect(state.searchResults.length, 4);
    });

    test('Empty trips list should handle gracefully', () {
      final searchController = container.read(testSearchProvider.notifier);

      searchController.setTrips([]);
      searchController.setSearchQuery('Bali');

      final state = container.read(testSearchProvider);
      expect(state.searchResults, []);
    });
  });
}