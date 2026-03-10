import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/search/search_state.dart';
import 'package:trips/providers/trip/trip_controller.dart';

class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() {
    // Initial state
    return SearchState.initial();
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

  // Method untuk filter berdasarkan bulan, tahun, dan kategori
  void filterByMonthYearCategory(String month, String year, String category) {
    state = state.copyWith(
      filterMonth: month,
      filterYear: year,
      filterCategory: category,
      searchQuery: category,
    );
    _performSearch();
  }

  void _performSearch() {
    // Ambil semua trips dari provider
    final tripState = ref.read(tripProvider);
    var results = List<TripModel>.from(tripState.trips);

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

    // Filter berdasarkan status menggunakan startDate dan endDate
    final now = DateTime.now();
    if (state.filterStatus == 'upcoming') {
      results = results.where((trip) => trip.startDate.isAfter(now)).toList();
    } else if (state.filterStatus == 'ongoing') {
      results = results.where((trip) =>
      trip.startDate.isBefore(now) && trip.endDate.isAfter(now)).toList();
    } else if (state.filterStatus == 'completed') {
      results = results.where((trip) => trip.endDate.isBefore(now)).toList();
    }

    // Filter berdasarkan bulan dan tahun (jika ada)
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

    // ========== SORTING ==========
   switch (state.sortBy) {
      case 'price':
        results.sort((a, b) {
          int comparison = a.price.compareTo(b.price);
          return state.sortAscending ? comparison : -comparison;
        });
        break;
      case 'rating':
        results.sort((a, b) {
          int comparison = a.rating.compareTo(b.rating);
          return state.sortAscending ? comparison : -comparison;
        });
        break;
      case 'title':
        results.sort((a, b) {
          int comparison = a.title.compareTo(b.title);
          return state.sortAscending ? comparison : -comparison;
        });
        break;
      default:
      // Default: sort by rating descending
        results.sort((a, b) => b.rating.compareTo(a.rating));
    }

    // Update state dengan hasil pencarian
    state = state.copyWith(searchResults: results);
  }

  int? _monthNameToNumber(String monthName) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    return months[monthName];
  }

  void resetFilters() {
    state = SearchState.initial();
    _performSearch();
  }
}

// Provider
final searchProvider = NotifierProvider<SearchController, SearchState>(
      () => SearchController(),
);